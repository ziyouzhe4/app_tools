
lane :automatic do |option|

  workspace = option[:workspace]
  input_file = option[:input_file]
  output_file = option[:output_file]

  UI.important "workspace: #{workspace}"
  UI.important "input_file: #{input_file}"
  UI.important "output_file: #{output_file}"

  app_config = YAML.load_file(input_file)
  scheme = app_config['scheme']
  target = app_config['target']
  app_identifier = app_config['app_identifier']
  bundle_version = app_config['bundle_version']
  xcworkspace = File.expand_path(app_config['xcworkspace'],workspace)
  configuration = app_config['configuration']
  export_method = app_config['export_method']

  message = ["💐 构建成功"]
  h = {}

  # 1.
  pod_install(workspace:workspace)


  # 2.
  ret = build(
      workspace: workspace,
      scheme: scheme,
      taget: target,
      app_identifier: app_identifier,
      bundle_version: bundle_version,
      xcworkspace: xcworkspace,
      configuration: configuration,
      export_method: export_method
  )

  ipa_output_path = ret[:ipa_output_path]
  output_directory = ret[:output_directory]
  # ipa_output_path = '/Users/majianjie/Desktop/RubyiOS/derived_data/products/output.ipa'
  # output_directory = '/Users/majianjie/Desktop/RubyiOS/derived_data/products'
  h[:ipa_size] = file_size(ipa_output_path)

  message << "ipa大小： #{h[:ipa_size]}"

  # 3.
  # ipa_download_url = upload(file_path: ipa_output_path)
  ipa_download_url = '/Users/majianjie/Desktop/RubyiOS/derived_data/products/output.ipa'
  h[:ipa_download_url] = ipa_download_url

  message << "ipa 下载地址： #{ipa_download_url}"


  # 4.
  info_plist_path = File.expand_path("info.plist",output_directory)
  generate_plist(
      output: info_plist_path,
      app_identifier: app_identifier,
      bundle_version: bundle_version,
      ipa_download_url: ipa_download_url,
      title: "MR 测试包"
  )

  # 5. upload plist
  # plist_download_url = upload(file_path:info_plist_path)
  plist_download_url = '/Users/majianjie/Desktop/RubyiOS/derived_data/products/info.plist'
  h[:plist_download_url] = plist_download_url

  # 6. qr_code
  qr_code_url = qr_code(plist_download_url: plist_download_url)
  h[:qr_code_url] = qr_code_url

  message << "二维码安装二维码： #{qr_code_url}"

  # 7.

  wechat(
      webhook_url: 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=910675eb-f6d1-4426-ba11-d1d05b8a9bb6',
      type: :text,
      message: message.join("\n")
  )

  message << "keywords: jack"

  ding_talk_msg_push(token:'f10b683af84f011ed50f329c16ffc5230219734c2b4022d4ff0a48512a063eee', text:message.join("\n"), at_all: true)


  # deploy



  File.open(output_file,'w+'){|f| f.write(JSON.pretty_generate(h))}

end