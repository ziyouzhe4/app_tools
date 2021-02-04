
lane :build do |option|

  workspace = option[:workspace]
  scheme = option[:scheme]
  taget = option[:target]
  app_identifier = option[:app_identifier]
  bundle_version = option[:bundle_version]
  xcworkspace = option[:xcworkspace]
  configuration = option[:configuration]
  export_method = option[:export_method]

  derived_data_path = File.expand_path('derived_data',workspace)
  output_directory = File.expand_path("products",derived_data_path)
  buildlog_path = derived_data_path
  output_name = 'output'

  args = {}

  args[:silent] = true
  args[:workspace] = xcworkspace
  args[:scheme] = scheme
  args[:configuration] = configuration
  args[:derived_data_path] = derived_data_path
  args[:output_directory] = output_directory
  args[:buildlog_path] = buildlog_path
  args[:output_name] = output_name
  args[:export_method] = export_method

  export_options = {}
  export_options[:compileBitcode] = false
  args[:export_options] = export_options

  build_ios_app args

  {
      derived_data_path: derived_data_path,
      output_directory: output_directory,
      ipa_output_path: Actions.lane_context[Actions::SharedValues::IPA_OUTPUT_PATH],
      dsym_output_path: Actions.lane_context[Fastlane::Actions::SharedValues::DSYM_OUTPUT_PATH]
  }

end