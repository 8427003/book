# http缓存

一般浏览器都实现了 HTTP 缓存！ 我们所要做的就是，确保每个服务器响应都提供正确的 HTTP 头指令，以指导浏览器何时可以缓存响应以及可以缓存多久。

Expires 或 Cache-Control:max-age 组成缓存第一道“防线”。如果没有超过缓存失效时间，那么将直接从浏览器本地获取缓存资源。从浏览器调试工具network可以看到如图状态：（注意status此时为200）

![from cache](/assets/from-cache.png)

确保devtools设置如下：去掉勾选（Disable cache\)

![](/assets/setting.png)

如果过期，则进入第二道“防线”。第二道“防线”由 Last-Modified 或 Etag 担任。请求时会带上请求头字段:

```
If-Modified-Since:Fri, 03 Jun 2016 07:06:57 GMT

If-None-Match:W/"57512c91-986b"
```

它们分别与响应头字段Last-Modified 和 Etag对应。这里所携带的值，就是上一次响应头字段的值。（注意，这里发送了一个请求，如果状态为304表示，则表示资源并未更改过，可以从本地缓存里取）如图：

![304](/assets/304.png)

至此，浏览器缓存大致可总结为有两级缓存。但是这些字段之间有啥区别，使用细节如何，已下继续讨论。

# Expires vs max-age

# Last-Modified vs Etag

