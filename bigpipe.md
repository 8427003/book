# bigpipe vs 静态页面

要想网页响应速度快，其实最简单可行的方法是将它生成静态页面就好了。但是有些页面不适合生成静态页面：比如首页，或者列表页，以及那些数据在实时变化的页面。像某个产品的详情页这种就适合生成静态页面，因为数据更新不频繁。所以对于那种不适合用生成静态页面来解决的场景我们怎么办呢？maybe bigpipe能派上用场。

# bigpipe 解决了什么问题

衡量一个页面的性能，其中一个重要指标，是这个页面“白屏”时间。这与yahoo的优化建议`Flush the Buffer Early`有相似之处。其实我们用传统的web技术就能实现这个优化：

```
echo "a";
sleep(1);
echo "b";
```

当server向client传递数据时，我们很容易让server先传字符“a",client渲染字符“a”，过一秒后，传递“b”时，再渲染“b”。并不需要server把字符“a”、“b”都收集完后才整个传递给client端，要知道等所有数据都收集完成，这个时间是很漫长的，client会一直处于白屏，client也从来没这样要求过。在于开发者怎么优化了。

那为何还要bigpipe呢？虽然传统技术能优化这样的“白屏”时间问题。但是server能先传递字符“b”，再传递字符“a”么？显然不行。这样的话client渲染时数据“b”就在数据"a"前面了，渲染顺序就与逻辑期望的不一致了。bigpipe实现需要前后端结合，它能够灵活解决渲染顺序问题，甚至是优先级问题。

# http0.9 vs http1.0 vs http1.1

0.9只支持get请求，1.0相比0.9多了post请求，1.1相比1.0没太多本质上的改变。http最开始是不支持长连接的。从1.0开始，加入了

```
Connection: keep-alive
```

所以各位兄弟姐妹，请记住了这个头不是1.1提出的。现在使用的基本都是http1.1协议。除非显示加上

```
Connection: close
```

http1.1默认是长连接。

# http 长连接

不是长连接时，只要server端或者client端close，两端都会知道这个连接已经断开了，需要数据通信时，再重新建立连接。但是长连接就不一样了，不能close。那两端总不能傻等着吧？要知道，如果不再需要数据传递，就应该把连接标示为空闲，因为长连接，这个连接要被其它需要数据通信的程序复用，传递其它数据。于是乎长连接下，增加了两个头

```
Content-Length 和 Transfer-Encoding: chunked

```

这两种方式都可以标识不再需要数据传递，这个连接可以放到空闲池，以备它用。

http1.0 在长连接时，必须要加

```
Content-Length
```

非长连接，直接close掉就行了。

http1.1长连接时，可以用

```
Content-Length 或 Transfer-Encoding: chunked

```

其中一个。两个同时使用时，Transfer-Encoding: chunked 优先级高。

# Content-Length vs Transfer-Encoding: chunked

当传递数据大小固定时，比如静态资源，一般使用Content-Length，因为静态资源大小很容易获得。

当数据是动态，又急需要将部分数据返回给客户端时，举个例子：

比如ui层需要返回一个页面数据，这个页面数据由三块构成，每块数据源都是call远程服务而获得。这个时候可以等三块数据都ready了，然后计算个总的大小用content-length。但这种白屏时间就比较久，不是一个很好的方案。此时就可以用Transfer-Encoding: chunked。每当有一块ready了，就传输给client端，让它渲染（假设渲染效果没有顺序要求）。

现在基本所有文档类型为text/html的资源在http1.1下都是使用Transfer-Encoding: chunked。可以看看百度首页，任意其它页面。

这两种方式具体使用可以参考：

https://imququ.com/post/transfer-encoding-header-in-http.html

# bigpipe 与 Transfer-Encoding: chunked 什么关系,http0.9能实现bigpipe吗？

现在使用http协议基本都是长连接。那么在长连接下只能使用

```
Content-Length 或 Transfer-Encoding: chunked

```

而
Content-Length 显然不适合使用。因为server不能一开始就知道整个需要传递的页面的总大小。所以只能是使用

```
Transfer-Encoding: chunked
```

但是如果不考虑长连接，bigpipe是照样可以在http1.0甚至是http0.9使用的。因为socket，flush一次，server端就会向client传递数据，client就能把这次的数据渲染出来。并非等待整个页面数据都传递给了client端，client端才开始渲染。这与文章开始讨论 “bigpipe 解决了什么问题”涉及知识一样。

以下是个实际例子：

```
var a = "xxxxxxxx" // 多点数据，因为浏览器有buffer,多于1024个字符。
var c = "123456789";
require('net').createServer(function(sock) {            
    sock.on('data', function(data) { 
        sock.write('HTTP/1.1 200 OK\r\n'); 
        sock.write('Content-Length: '+a.length+9*2+'\r\n');
        sock.write('\r\n'); 
        sock.write(a); 
        setInterval(function (){ 
            sock.write(c); 
        }, 3000);
    });
}).listen(9090, '127.0.0.1');

```
#### 结论：bigpipe只依赖于是否能分段输出，而socket本身就具有这样的能力。

# 注意

bigpipe测试时有很多缓存控制。比如nginx，或者webserver的，浏览器也有1024字符。比如你有两个字符片段，想通过两次数据传递，或者想看到的效果是paint两次显示出来，但是各个环节有作优化，先buffer起来，再一起传递或渲染。

# 参考

yahoo:Best Practices for Speeding Up Your Web Site
https://developer.yahoo.com/performance/rules.html

http://www.cnblogs.com/xpress/archive/2011/07/21/2112382.html

http://www.cnblogs.com/CareySon/archive/2012/04/27/HTTP-Protocol.html

http://www.kafsemo.org/2015/01/03_talking-HTTP-0.9,1.0,1.1.html

http://stackoverflow.com/questions/10723812/if-a-http-1-0-client-requests-connection-keep-alive-will-it-understand-chunked

https://www.byvoid.com/blog/http-keep-alive-header 翻墙打开

https://tools.ietf.org/html/rfc2068#section-19.7.1

https://www.w3.org/Protocols/HTTP/1.0/spec.html#Augmented-BNF

https://www.w3.org/Protocols/rfc2616/rfc2616.html#Augmented-BNF

