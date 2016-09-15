# 背景

我的blog代码托管在github上，想通过travis在提交代码时自动发布到远程服务器指定目录。本篇文章主要介绍利用travis持续集成来完成此项工作。

# shell脚本
```
sshpass -p woshimima scp -P 29134 -o stricthostkeychecking=no -r ./_book/* root@www.css3.io:/nginx/html/

```

##  shell脚本介绍

**持续集成自动化运行脚本最大的一个问题在于脚本在运行的时候是没有一个交互界面的，所以你不可以输入密码，不可以输入yes确认。**

1. sshpass 是一个简单的命令行工具，scp的时候会提示输入密码，这个工具的作用是可以将密码预先设置，从而使脚本可以自动化。

    `sshpass -p woshimima` **-p**参数是指定密码为`woshimima`

2. `scp -o stricthostkeychecking=no` 这个参数是必须的，告诉





