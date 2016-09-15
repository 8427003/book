---
keywords: travis,sshpass,stricthostkeychecking,部署到远程服务器,deploy,remote server
---

# 背景

我的blog代码托管在github上，想通过[travis](https://travis-ci.org)在提交代码时自动发布到远程服务器指定目录。本篇文章主要介绍利用travis持续集成来完成此项工作。

# 部署脚本
```
sshpass -p woshimima scp -P 29134 -o stricthostkeychecking=no -r ./_book/* root@www.css3.io:/nginx/html/

```

##  部署脚本介绍

**持续集成自动化运行脚本最大的一个问题在于脚本在运行的时候是没有一个交互界面的，所以你不可以输入密码，不可以输入yes回车键确认。而我们常用的一些shell命令是有一些交互的，比如scp、ssh 是要输入密码的，所以我们必须通过一些其它方式来解决这一类问题。**

1. sshpass 是一个简单的命令行工具，scp的时候会提示输入密码，这个工具的作用是可以将密码预先设置，从而使脚本可以自动化。

    `sshpass -p woshimima` **-p**参数是指定密码为`woshimima`

2. `scp -o stricthostkeychecking=no` 这个参数是必须的，禁用 SSH 远程主机的公钥检查。当我们用ssh第一次登陆服务器，通常会提示是否需要导入服务器公钥，看起来会是这样

    _The authenticity of host '192.168.0.110 (192.168.0.110)' can't be established. RSA key fingerprint is a3:ca:ad:95:a1:45:d2:57:3a:e9:e7:75:a8:4c:1f:9f. Are you sure you want to continue connecting (yes/no)?_

    我们说了，是没有交互界面的，如果遇到这样的选择，我们的自动化脚本将会不能正常执行（这里的一个实际场景是，看到travis日志脚本没有返回任何错误，但是脚本没有工作）。针对ssh禁用公匙检查可以参考这篇文章http://www.worldhello.net/2010/04/08/1026.html

3. 更多scp命令的详细使用，比如参数** scp -r ./_book/***代表发送_book下文件包括子目录就不作更多讨论。

# 安全问题

travis项目是公开的（除非你花钱买私有的），任何人可以看到公开项目的日志，这样的脚本会暴露服务器ssh密码。好在travis提供了解决方案，我们可以将ssh密码，用户名，端口等加密。
我们能够告诉travis在使用sshpass时从环境变量读取变量而非命令行。利用[`travis` command line tool](https://github.com/travis-ci/travis.rb)增加加密变量。

假设你已经在本机安装了**`travis` command line tool**

``` 
travis encrypt DEPLOY_USER=<csun-username> 
travis encrypt DEPLOY_PASS=<csun-password> 

```
在有`travis.yml` 文件的项目中运行以上命令时，travis会自动注入`global`节点到`travis.yml` 文件中。如果不是，你也可以从命令行得到值后copy加密后的值进`travis.yml`文件。`travis.yml`看起来像这样：

```
env: 
    global: 
    - secure: "..." 
    - secure: "..." 
```
我们部署脚本就可以直接使用变量了

```
export SSHPASS=$DEPLOY_PASS
sshpass -e  scp -P 29134 -o stricthostkeychecking=no -r ./_book/* $DEPLOY_USER@www.css3.io:/nginx/html/

```

#最后

完整travis配置参考我的blog项目
https://github.com/8427003/book/blob/master/.travis.yml

#总结

重要的事情说三遍，持续集成自动脚本没有交互，我们必须得用一些track的方式解决这个问题。当时用sshpass解决了输入密码的问题，但是没有注意到**禁用 SSH 远程主机的公钥检查**，卡住了很久。本机上可以正常使用（因为本机登陆过服务器，不是第一次登陆，所以不检查公钥），而在travis服务上，脚本始终不正常工作，也不提示错误。

# 参考

http://www.worldhello.net/2010/04/08/1026.html

http://www.csun.edu/~see93462/primer_project/cgi-bin/index.cgi?raw=true




