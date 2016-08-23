# 背景

以前被人问起GET请求与POST请求区别。一般人都能答出：

* 长度、安全、浏览器后退，历史记录等行为不同
* get一般用于查询数据，post一般用于写入数据


**然后有人提出了一个杀手锏的区别，99%的人都不知道，那就是：GET产生一个TCP数据包；POST产生两个TCP数据包。**

对于GET方式的请求，浏览器会把http header和data一并发送出去，服务器响应200（返回数据）；

而对于POST，浏览器先发送header，服务器响应100 continue，浏览器再发送data，服务器响应200 ok（返回数据）。

参考这篇文章的观点：

http://gold.xitu.io/entry/57597bd45bbb500053c88b4c

情况真的是这样么？我们来验证下！

# 实验



我们先跑一段基于node平台的webserver程序，开始监听http://127.0.0.1:9090

```javascript

require('net').createServer(function(sock) { 

    sock.on('data', function(data) { 

        sock.write('HTTP/1.1 200 OK\r\n'); 

        sock.write('Transfer-Encoding: chunked\r\n'); 

        sock.write('\r\n');

        sock.write('5\r\n'); 

        sock.write('12345\r\n');

        sock.write('0\r\n'); 

        sock.write('\r\n'); 
    });

}).listen(9090, '127.0.0.1');

```

打开[wireshark](https://www.wireshark.org/),捕获Loopback接口（因为我们捕获的是服务端地址是127.0.0.1，不需要捕获其它网卡接口），过滤规则:`tcp.port == 9090`

**测试GET请求**

我们先用postman发起**get**请求并带一个`test`参数即`http://127.0.0.1:9090/?test`。

wireshark得到如下记录:

图get-1
![](/assets/get-1.png)

当前选中帧，为postman向webserver发送数据的帧。点开进一步观察

图get-2
![](/assets/get-2.png)

从图get-2发现这一帧确实发送了消息头和实体（当前选中行应该是表示消息头结束，下面就是body）
从图get-1也看到，第6帧是webserver端给postman的响应。证明get请求已发送完毕。

**再测试POST请求**

参数为hehe

图post-1
![](/assets/post-1.png)

图post-2
![](/assets/post-2.png)

似乎我们在这一帧直接就看到了请求body我们的参数`hehe`.**看来并不是发送了两个数据包。
**

但是这个观点总不是空穴来风吧。有可能是wireshark这款工具使用问题，或者看不出来。

我接着增大了参数的大小，也就是扩大了body（增加到了1000个字符左右）

图post-3

![](/assets/post-3.png)

图post-4

![](/assets/post-4.png)

从图post-4中看出这次的http请求由两帧组成，也就是post-3选中的第63帧和当前打开的64帧，查看63帧详情时，果然只有`消息头`, 64帧是body内容。跟上面文章的观点基本一致。唯一不一致的是并没有看到server返回状态码100之类的信息，第65帧就server端对客户端63帧的响应。

**那get请求也会因为参数增大而发两个包么？**

我作了进一步实验，并没发现此现象。

图get-3
![](/assets/get-3.png)

# 结论

1. get请求确实只发送了1个包

2. post请求在参数少时也只看见发送了1个包，在参数增大时，发现确实在消息头和body被分割成了两个包，甚至根据body大小，分割成更多包。

# 申明

实验环境基于mac，postman，wireshark，传递参数大小仅验证了字符`hehe` 和 “1000个字符” 长度数据。可能具有一定不准确性。