# 背景

使用yum安装软件时，会经常遇到安装的软件是老版本的，被非自己期望的release版本。这到底是怎么回事儿，得从`rpm`，`yum`，`yum repositories`说起。

# rpm

[RPM Package Manager](https://en.wikipedia.org/wiki/RPM_Package_Manager) 是一个包管理系统。管理着许多格式为xxx.rpm的软件，多是二进制包。这些软件都是针对某种平台下编译的，所以可以找准与自己平台对应的包，直接下载安装使用。但是有一个问题，如果使用`rpm -i example.rpm`直接去安装这些包时，包会有依赖（比如这个软件需要什么动态库，或者需要python等环境，或者其它什么软件才能运行），必须先安装依赖。这就老火了，手动去安装依赖，依赖还有依赖，最终会非常多的依赖要安装。然后 [yum](https://fedoraproject.org/wiki/Yum)就排上用场了，yum最主要的就时解决依赖问题。

# yum

`yum install xxx`  就可以安装软件了，依赖也同时被安装。我们的问题来了，通常这样安装软件我们经常遇到安装了一个老版本，

比如` yum install git `或者 `yum install nodejs `这是怎么回事儿呢？这跟yum 使用的**源**有关系，请看源的介绍。



# yum repository

repository 简单来说就是对应一个url，这个url是个列表，里面有很多的软件包。当yum install xxx, 就在里面去查找xxx 以及xxx的依赖。如果这repository里放的xxx是一个低版本的，我们安装的就是个低版本的软件了。

yum 可以同时使用多个 repository，一搬在/etc/yum.repos.d/ 路径下，比如我就有这么多

```
CentOS-Base.repo       CentOS-Media.repo  epel-testing.repo      webtatic.repo
CentOS-Debuginfo.repo  CentOS-Vault.repo  nodesource-el6.repo    webtatic-testing.repo
CentOS-fasttrack.repo  epel.repo          webtatic-archive.repo
```

# .repo

打开.repo文件看，会发现一个.repo文件里面有多个节点，每个节点对应了一个url，这就是我们前面提到的装有很多软件包的url了。节点叫什么名字并不重要，一个.repo里可以包含1个或者多个节点。当yum install xxx安装时，会在每个节点对应的url去查找（前提是每个节都启动了），默认滴会安装xxx最新的一个版本。当然你可以yum list xxx 列出所有的版本，选择安装。yum search xxx是搜索，这个和list 有区别，list是只列出name， search 会去找name, descript等信息包含xxx的软件包。更多可以了解[** yum list vs yum search**](https://www.centos.org/docs/5/html/yum/sn-searching-packages.html)。

其中，有个两个.repo非常重要，默认滴CentOS-Base.repo是主要的一个repository，里面指向了官方的源镜像地址。但是也有不够用的情况，所以[epel.repo](https://fedoraproject.org/wiki/EPEL)这个扩展包源就排上用场了，很多时候，会安装老的版本包，加入一个不一样的源，就可能安装一个新版本包了。因为这个新的源里面就有个比较新版的包，yum install xxx**会优先安装高版本**，epel就不多介绍了，还有一些有意思的源，这些源之所以有多种，是因为每个源里的包功能上不一样，比如有些源可能专放一些驱动，有些源专放一些其它工具等等。

# 如何为yum加入新的repository

你完全可以copy一个.repo，然后手动去改里面的url。也有更方便的方案，就直接yum install 安装，比如epel就可以_yum install epel_

-release.（官方提供了这样一个包，其它源里面也可以搜到）安装后，/etc/yum.repos.d/  路径下就多一个epel.repo文件了，已经自动配置好了。这种自动安装对比手动还是挺好的，因为你不必去记住url。

