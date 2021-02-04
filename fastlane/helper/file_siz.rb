
def file_size(file_path,log = true)

  total = 0
  return 0 unless File.exist?(file_path)

  base = File.basename(file_path)

  # return 0 if base == '.' or base = '..'

  dir = File.dirname(file_path)
  file_path = dir + '/' + base

  if File.directory?(file_path)
    printf("Dir: %s\n", file_path) if log
    Dir.foreach(file_path) do |file_name|
      total += get_file_size(file_path + '/' + file_name,log)
    end
  else
    size = File.stat(file_path).size
    printf("File: %s - %d byte\n", file_path,size) if log
    total += size
  end

  puts "ipa total size: #{total}"
  total

end