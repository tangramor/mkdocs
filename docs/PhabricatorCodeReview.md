#  Code Review 流程

## 设置 git 客户端

在参与 code review 流程前，我们需要保证开发人员的 git 客户端的用户信息正确（svn 因为由管理员配置好了，所以无需设置），否则开发人员将收不到邮件提醒。

进入你的项目目录，使用文本编辑器打开 `.git/config` 文件，在文件末尾添加用户信息：

```ini
[core]
        repositoryformatversion = 0
        filemode = false
        bare = false
        logallrefupdates = true
        symlinks = false
        ignorecase = true
[remote "origin"]
        url = git@gitlab.longtubas.com:root/example.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
        remote = origin
        merge = refs/heads/master
[user]
        name = 王俊华
        email = wangjunhua@longtugame.com
```

当然，你也可以使用 git 命令行设置用户信息（去掉 `--global` 就是只针对当前项目设置，否则是全局设置）：

```bash
  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
```



##  Phabricator

我们使用 Phabricator 进行 code review。使用 SSO 账号密码登录网站：http://code.longtubas.com：

![Phabricator000](./images/Phabricator000.png)

点击左侧菜单里的 **Diffusion** ：

![Phabricator首页](./images/Phabricator001.png)

你可以在页面上看到你有权限 review 的项目：

![Phabricator002](./images/Phabricator002.png)

进入某一个项目，查看开发人员的代码提交：

![Phabricator003](./images/Phabricator003.png)

点击开发人员的某次提交链接，或者选择一个文件查看该文件的提交历史并点击某个提交链接，都可以查看提交详情页面，在这里我们就可以进行 code review 了。我们可以对整个提交写 code review comment：

![Phabricator004](./images/Phabricator004.png)

也可以点击行号，对某些行进行评论：

![Phabricator005](./images/Phabricator005.png)

当评论提交后，相关开发人员会收到 email，类似：

![Phabricator006](./images/Phabricator006.png)