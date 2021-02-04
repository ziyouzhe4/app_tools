
task(:build) do

  



  cmds = ['bundle exec fastlane automatic']
  cmds << "workspace:#{Dir.pwd}"
  cmds << "input_file:#{File.expand_path('.build.yaml',Dir.pwd)}"
  cmds << "output_file:#{File.expand_path('.output.json',Dir.pwd)}"

  system(cmds.join(' '))

end

task(default: %i[build])