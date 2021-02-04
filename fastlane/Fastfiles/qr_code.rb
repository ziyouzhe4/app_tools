
def url_encode(url)
  ERB::Util.url_encode(url)
end

def itms_services_url(plist_url)
  "itms_services://?action=download-mainfest&url=#{plist_url}"
end

lane :qr_code do |options|

  plist_download_url = options[:plist_download_url]

  # 1.
  m_itms_services_url = itms_services_url(plist_download_url)

  # 2.
  m_coded_itms_services_url = url_encode(m_itms_services_url)

  # 3.
  "https://api.qrserver.com/v1/create-qr-code/?size=200x200&margin=10&data=#{m_coded_itms_services_url}"


end