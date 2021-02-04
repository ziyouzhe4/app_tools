
task(:build) do

  workspace = ENV['workspace']
  app_git = ENV['app_git']
  app_branch = ENV['app_branch']
  app_path = File.expand_path('app',workspace)

  cmds = ["git clone #{app_git} #{app_path}"]
  cmds << "-b #{app_branch}"
  # cmds << "--depth=1"
  # cmds << "--single-branch"

  system(cmds.join(' '))



  cmds = ['bundle exec fastlane automatic']
  cmds << "workspace:#{app_path}"
  cmds << "input_file:#{File.expand_path('.build.yaml',app_path)}"
  cmds << "output_file:#{File.expand_path('.output.json',app_path)}"

  system(cmds.join(' '))

end

task(default: %i[build])