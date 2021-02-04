
lane :pod_install do |option|

  workspace = option[:workspace]

  Actions.sh("cd #{workspace}; bundle exec pod install")

end