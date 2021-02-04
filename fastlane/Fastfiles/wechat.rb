
lane :wechat do |params|

  webhook_url = params[:webhook_url]
  type = params[:type].to_sym
  message = params[:message]
  to = params[:to]
  fail_on_error = params[:fail_on_error]

  bot = WeChatWorkGroupBot.new(webhook_url)
  response = bot.send(type, message, to)
  if response
    parse_response(response, fail_on_error)
  else
    message = "Error pushing Wechat Work message: #{bot.exception.message}"
    if fail_on_error
      UI.user_error!(message)
    else
      UI.error(message)
    end
  end

end

def parse_response(response, fail_on_error)
  body = JSON.parse(response.body)

  if body.key?('errcode') && body['errcode'].zero?
    UI.success('Successfully sent Wechat Work notification')
  else
    UI.verbose(body)
    message = "Error pushing Wechat Work message: [#{body['errcode']}] #{body['errmsg']}"
    if fail_on_error
      UI.user_error!(message)
    else
      UI.error(message)
    end
  end
end

class WeChatWorkGroupBot
  require 'net/http'
  require 'digest'
  require 'base64'
  require 'json'

  MESSAGE_TYPES = [:text, :markdown, :image, :news].freeze
  IMAGE_TYPES = ['jpg', 'jpeg', 'png'].freeze

  attr_reader :exception

  @exception = nil

  def initialize(webhook_url)
    @webhook_url = URI(webhook_url)
  end

  def send_message(text, to = nil)
    send(:text, text, to)
  end

  def send_markdown(text, to = nil)
    send(:markdown, text, to)
  end

  def send_image(image_file, to = nil)
    # send(:image, image_file, to)
  end

  def send_news(title, description, image_url, link)
  end

  def send(type, text, to = nil)
    determine_type!(type)

    @exception = nil
    data = build_body(type, text, to)
    Net::HTTP.post(@webhook_url, data.to_json, 'Content-Type' => 'application/json')
  rescue => e
    @exception = e

    nil
  end

  private

  def build_body(type, message, to)
    data = {}
    data[:msgtype] = type
    if type == :image
      # NOTE: 图片（base64编码前）最大不能超过2M，支持JPG,PNG格式

      file = message
      determine_image!(file)
      data[type] = {
          base64: image_base64_encode(file),
          md5: Digest::MD5.file(file)
      }
    else
      data[type] = { content: message }
    end

    data[type].merge!(handle_mention(to))
    data
  end

  def handle_mention(to)
    list = {
        mentioned_list: [],
        mentioned_mobile_list: [],
    }

    tos = []
    case to
    when String
      tos << to
    when Array
      tos.concat(to)
    end

    tos.each do |value|
      if mobile_phone_number?(value)
        list[:mentioned_mobile_list] << value
      else
        list[:mentioned_list] << value
      end
    end

    list
  end

  def mobile_phone_number?(value)
    value.match(/\d{11}/)
  end

  def image_base64_encode(path)
    File.open(path, 'rb') do |file|
      Base64.strict_encode64(file.read)
    end
  end

  def determine_type!(type)
    raise "Not match type: #{type}, avaiable in : #{MESSAGE_TYPES}" unless MESSAGE_TYPES.include?(type)
  end

  def determine_image!(file)
    raise 'Not a image file' unless File.file?(file)
    raise 'Only avaiable in JPG, PNG image' unless IMAGE_TYPES.include?(File.extname(file))
  end
end