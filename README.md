## MBRjun-Blog
MBRjun-Blog 的源码仓库  

这是一个使用 Hexo 搭建的 Blog，所有文章已在 2023 年 1 月 1 日发布到 [blog.mbrjun.cn](https://blog.mbrjun.cn)，旧的 Typecho Blog 已被备份保存  

出于性能和一些其他原因，该 Blog 已从 Typecho 转移到 Hexo 平台  


## 构建
该 Blog 使用 GitHub Action 实现自动构建，如果你希望手动构建，你需要：  

1. 使用一台基于 Debian GNU/Linux 的机器执行 modify/env.sh，系统可能会要求您输入电脑的密码
2. 使用 ``hexo s debug`` 命令开启一个 Web 服务器来实时调试，使用 ``hexo generate`` 命令进行生产构建  
