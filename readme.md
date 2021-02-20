###使用指南：

####0. 新建 存放项目的工作空间 workspace: 

执行命令： `<mkdir workspace>`

####1. 在桌面新建 存放 脚本工具链 目录: app_tools

执行命令： `<mkdir app_tools>`

执行命令： `<cd app_tools>`

####2. 将脚本工具链clone到本地

执行命令： `git clone https://github.com/ziyouzhe4/app_tools.git -b master`

进入脚本工具链目录： `cd app_tools` 后执行 `<bundle install>` 安装

在改目录下执行 `<bundle exec rake workspace='刚刚你新建的workspace目录' app_git='你自己要克隆的gi仓库地址' app_branch='master'>`


