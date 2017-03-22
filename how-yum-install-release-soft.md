# 背景

使用yum安装软件时，会经常遇到安装的软件是老版本的，被非自己期望的release版本。这到底是怎么回事儿，得从`rpm`，`yum`，`yum repositories`说起。

# rpm

[RPM Package Manager](https://en.wikipedia.org/wiki/RPM_Package_Manager) 是一个包管理系统。管理着许多格式为xxx.rpm的软件，多是二进制包。这些软件都是针对某种平台下编译的，所以可以找准与自己平台对应的包，直接下载安装使用。但是有一个问题，如果像使用`rpm -i example.rpm`直接去安装这些包时，包会有依赖（比如这个软件需要什么动态库，或者需要python等环境，或者其它什么软件才能运行），必须先安装依赖。这就老火了，手动去安装依赖，依赖还有依赖，最终会非常多的依赖要安装。然后 [yum](https://fedoraproject.org/wiki/Yum)就排上用场了，yum最主要的就时**解决依赖问题**。

# yum

`yum install xxx`  就可以安装软件了，依赖也同时被安装。我们的问题来了，通常这样安装软件我们经常遇到安装了一个老版本，

比如`yum install git`或者 `yum install nodejs`时就安装了一个低版本的软件，这是怎么回事儿呢？这跟yum 使用的**源**有关系，请看源（repository）的介绍。

# yum repository

repository 简单来说就是对应一个url（专业叫镜像地址），这个url是个列表，里面有很多的软件包。当yum install xxx, 就在里面去查找xxx 以及xxx的依赖。如果这repository里放的xxx是一个较低版本的，我们安装的就是个低版本的软件了。

yum 可以同时使用多个 repository，一搬在`/etc/yum.repos.d/`路径下，比如我就有这么多

```
CentOS-Base.repo       CentOS-Media.repo  epel-testing.repo      webtatic.repo
CentOS-Debuginfo.repo  CentOS-Vault.repo  nodesource-el6.repo    webtatic-testing.repo
CentOS-fasttrack.repo  epel.repo          webtatic-archive.repo
```

# .repo

打开`.repo`文件看，会发现一个`.repo`文件里面有多个节点，每个节点对应了一个url，这就是我们前面提到的装有很多软件包的url了。节点叫什么名字并不重要，一个`.repo`里可以包含1个或者多个节点。当`yum install xxx`安装时，会在每个节点对应的url去查找（前提是每个节都启动了），默认滴会安装xxx最新的一个版本。当然你可以`yum list xxx` 列出所有的版本，选择安装。`yum search xxx`是搜索，这个和**list** 有区别，**list**是只列出_name_， **search** 会去找_name_, _descr（每个包拥有一些基本信息name，desc等等）_等信息包含xxx的软件包。更多可以了解[** yum list vs yum search**](https://www.centos.org/docs/5/html/yum/sn-searching-packages.html)。

其中，有个两个**.repo**非常重要，默认滴**CentOS-Base.repo**是主要的一个repository，里面指向了官方的源镜像地址。但是也有不够用的情况，所以[**epel.repo**](https://fedoraproject.org/wiki/EPEL)这个扩展包源就排上用场了，很多时候，会安装老的版本包，加入一个不一样的源，就可能安装一个新版本包了。因为这个新的源里面就有个比较新版的包，`yum install xxx`**会优先安装高版本**，**epel**就不多介绍了，还有一些有意思的源，这些源之所以有多种，是因为每个源里的包功能上不一样，比如有些源可能专放一些驱动，有些源专放一些其它工具等等。

# 如何为yum加入新的repository

你完全可以copy一个`.repo`，然后手动去改里面的url。也有更方便的方案，就直接`yum install`安装，比如epel就可以`yum install epel-release`.（官方提供了这样一个包，其它源里面也可以搜到）安装后，`/etc/yum.repos.d/` 路径下就多一个**epel.repo**文件了，已经自动配置好了。这种自动安装对比手动还是挺好的，因为你不必去记住url。有一个问题，多个源尽量不要混着使用，可能引发依赖问题，或者严重的软件跑不起来，更多参考[http://dag.wiee.rs/rpm/FAQ.php\#D1。 ](http://dag.wiee.rs/rpm/FAQ.php#D1。针对这个问题，我的理解是，混合使用源下载的依赖可能来自其它的源，而其它的源下载的依赖包并非你安装包期望的版本，或者是底层的存储架构（想要个x86)针对这个问题，我的理解是，混合使用源下载的依赖可能来自其它的源，而其它的源下载的依赖包并非你安装包期望的版本，或者是底层的存储架构（想要个x86 64的下了i386 32的）具体也没见文章说得很清楚，这里自己也有疑问，估计是yum的设计并非针对多个源混用，面对混用源，依赖方面做得有些不足。

# 当切换repository后依然下载老版本软件包

你会发现，你即使加了一个epel的源，有时候还是下的老版本。原理很简单，你所有的源里面，最高版本就是那个老版本包。举个实际例子，`yum install nodejs` 的时候，即使你有epel也只能安装0.10.x的版本。其实有解决方案的，这种情况你去看官方是否提供了一个源，比如nodejs官方就提供[https://nodejs.org/en/download/package-manager/\#enterprise-linux-and-fedora.](https://nodejs.org/en/download/package-manager/#enterprise-linux-and-fedora.通过命令，你会下载一个rpm包，然后安装这个rpm包，会增加一个新的源。我这里就多了一个)  通过命令，你会下载一个**nodesource-release-el6-1.noarch.rpm**包，然后安装这个rpm包，**会增加一个新的源**。我这里就多了一个 **nodesource-el6.repo**源（这个源里面仅仅放了nodejs相关的软件包，及其依赖包），此时你再去 yum install nodejs，就会发现安装的是新版本了。

# 参考

[https://nodejs.org/en/download/package-manager/\#enterprise-linux-and-fedora](https://nodejs.org/en/download/package-manager/#enterprise-linux-and-fedora)

[https://www.centos.org/docs/5/html/yum/sn-searching-packages.html](https://www.centos.org/docs/5/html/yum/sn-searching-packages.html)

[http://centoshelp.org/resources/repos/](http://centoshelp.org/resources/repos/)

[https://www.centos.org/docs/5/html/yum/sn-yum-maintenance.html](https://www.centos.org/docs/5/html/yum/sn-yum-maintenance.html)

[https://www.centos.org/docs/5/html/yum/index.html](https://www.centos.org/docs/5/html/yum/index.html)

[http://unix.stackexchange.com/questions/50657/is-it-stable-to-use-epel-and-rpmforge-in-the-same-time](http://unix.stackexchange.com/questions/50657/is-it-stable-to-use-epel-and-rpmforge-in-the-same-time)

[http://dag.wiee.rs/rpm/FAQ.php\#D1](http://dag.wiee.rs/rpm/FAQ.php#D1)

