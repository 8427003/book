# 背景
百度的很多项目是用php语言开发的。每当涉及到开发环境需要自己去维护时，php项目webserver的一堆东西感觉相当凌乱。促使自己必须去搞明白这些最基础的环境是如何搭建，如何配置的。以下是介绍php+hhvm的入门实践。hhvm百度的很多项目都在用时，包括百度贴吧，百度凤巢广告系统等等。
这里主要是学习搭建配置，所有环境都在本机mac上进行。

# nginx+hhvm 相关知识介绍
1、hhvm是facebook搞的一个将php语言编译成中间代码，然后runtime解释执行一个东西。速度嘛听贴吧的一些rd哥哥说只能比php快几倍、10倍不到吧。但是这也是一个可优化的点。网上对hhvm的评价各有不一，有人认为没必要用这个。有人说php7出来可以取代这个。但是我看到百度的只要是php服务，基本都用了这个。

2、apache接入php的方式是apache的一个模块。nginx接入其它第三方服务是通过它的fastcgi基本模块。php-fpm 是php自带的一个插件用来跟其它webserver接入用。php-fpm它是一个服务，socket服务。fastcgi是一个通讯协议。
它们的区别，和各自的职责也是一团乱麻。总之apache+php的方式跟nginx+php比，apache性能要低点。因为它的实现是多进程。nginx用的epoll。apache接入php是通过apache 的php扩展模块接入的。nginx接入php是通过fastcgi接入的。这里就引入了php-fpm概念。

```
贴几个地址参考：
http://yansu.org/2014/02/15/apache-and-nginx.html
http://my.oschina.net/shyl/blog/690093
https://segmentfault.com/q/1010000000256516
```
# 实战记录
## 1、nginx安装
nginx的安装相当简单。按照官方文档一步一步安装就行了。我们一般使用源代码自己build。

```
1、下载源码,解压。
2、cd进入源码根目录.
3、./configure --prefix=path 指定安装到什么路径下。为了简单，一个 prefix选项就够了，其它默认。
4、make
5、make install 注意这部，官方文档只到4，这是linux源文件安装3大步骤。
```

## 2、hhvm安装
vpn 翻墙 brew install hhvm 安装，官方文档有具体安装方式。这里最好用源代码build安装，为了简单实用了brew来安装。安装中可能会遇到一些问题，按错误提示解决就行。

### 3、nginx+hhvm配置并且启动
1、修改nginx的配置：
注意：nginx的配置文件nginx.conf中有些默认fastcgi接入配置被注释。如下：

```
 #location ~ \.php$ {
 # root html;
 # fastcgi_pass 127.0.0.1:9000;
 # fastcgi_index index.php;
 # fastcgi_param SCRIPT_FILENAME /scripts$fastcgi_script_name;
 # include fastcgi_params;
#}
```

原本以为对于接入hhvm取消这里，然后再改改就可以。结果犯错了。
a、注意每个语句后面有分号结束。

b、fastcgi\_param SCRIPT\_FILENAME \/scripts$fastcgi\_script\_name; 路径不正确，使用hhvm文档的才对。主要是\/scripts 这里应该使用$document\_root.不然会报404 not find!

c、这里使用的是UNIX Domain Socket来接入的。\/var\/run\/hhvm\/sock 不存在，需要手动创建。注意只创建到\/var\/run\/hhvm 目录就可以了。sock文件会在通信时由hhvm创建。不能手动创建sock文件。不然hhvm启动不了。原理估计得去实战下UNIX Domain Socket编程才行了。还要chown修改hhvm的目录权限，保证nginx和hhvm能写入。

最后完整的nginx.conf配置为:

```
location ~ \.php$ {
 #root html;
 root /Users/baidu/git/php/www;
 #fastcgi_pass 127.0.0.1:9000;
 fastcgi_pass unix:/var/run/hhvm/sock;
 fastcgi_index index.php;
 #fastcgi_param SCRIPT_FILENAME /scripts$fastcgi_script_name;
 fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
 include fastcgi_params;
}
```

剩下的按照nginx和hhvm的文档run服务吧。
