
lane :generate_plist do |options|

  output = options[:output]
  app_identifier = options[:app_identifier]
  bundle_version = options[:bundle_version]
  ipa_download_url = options[:ipa_download_url]
  title = options[:title]

  ipa_install_plist_generate(
      output: output,
      bundle_identifier: app_identifier,
      bundle_version: bundle_version,
      url: ipa_download_url,
      display_image: 'http://example.com/app.png',
      full_size_image: 'http://example.com/app.png',
      title: title

  )

end