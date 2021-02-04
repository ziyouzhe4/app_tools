
lane :upload do |options|

  file_path = options[:file_path]

  cmds = []
  cmds << "curl http://127.0.0.1:5000/upload"
  cmds << "-F \"file=@#{file_path}\""

  Actions.sh(cmds.join(" "))

  if $?.exitstatus.zero?
    UI.success('✅ 【upload_file】upload success: ')
    "http//127.0.0.1:5000/download/#{File.basename(file_path)}"
  else
    UI.error('❌ 【upload_file】 upload failed')
    nil
  end


end