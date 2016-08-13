# php实现分段输出demo

最简单demo:
```
echo 'hello';
flush();
ob_flush();
sleep(1);
echo 'world';
```
这是一个最简单的BigPipe demo，然而由于fastcgi_buffer的存在，并不能看到分段输出的效果。那么，我们把程序进行一下改动，用str_pad填充一些字符以达到buffer。

改进后demo:
```
echo str_pad('hello', 10000, ' ');
flush();
ob_flush();
sleep(1);
echo str_pad('world', 10000, ' ');
```
进行字符填充后，BigPipe效果显现了出来，hello之后过1秒后会才会出现world。

# nginx
Nginx对于网络请求会通过buffer进行优化，在反向代理层有proxy_buffer，在fastcgi层有fastcgi_buffer。
由于buffer的存在，如果包比较小的话BigPipe的chunked输出很可能会被buffer住。针对这种情况，一般来说有三种方式。

1.使用strpad这类函数进行填充，如：填充字符。永远将一次flush的数据填充到buffer_size。（如简单Demo所示）

2.调小buffer，让数据更容易达到buffer_size。

3.关闭buffer（按需）。


##### 如何选择：

第一种方式，不用调整buffer，但这种方式很不优雅，而且增加了带宽，并不是很合理。

至于调小buffer，这看起来是一个很好的思路，然而对于gzip过的数据来说，最小的buffer可能也比较大(补充：即使你把buffer设置得很小，但是gzip过后，这个值也相对较大）。

因此，我们选择了对于frsui模块按需关闭proxy_buffer和fastcgi_buffer。

##### 详见：

http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffering

http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_buffering

然而，这样带来了一个问题。线上运行中的Nginx 1.4.4版本过低，关闭proxy_buffer的指令proxy_buffering off指令原生就支持。而关闭fastcgi_buffer的fastcgi_buffering off指令需要1.5.6版本。所以百度Nginx技术小组提供的包中，1.7.8版本符合要求，我们首先需要把Nginx版本升级到了1.7.8。


为了将影响面做得最小，只需要关闭特定模块的buffer。改nginx.conf固然可以实现，不过对于不支持嵌套if的nginx.conf来说这是个很不便捷的用法。我们可以使用X-Accel-Buffering指令按需关闭buffer。
即从nginx的文档中我们发现

_Buffering can also be enabled or disabled by passing “yes” or “no” in the “X-Accel-Buffering” response header field. This capability can be disabled using the fastcgi_ignore_headers directive._

这两种buffer我们都可以配置上完全不用关闭buffer，只需要在php代码中加header把buffer优雅关闭。

```
header('X-Accel-Buffering: no');

```

即最终demo：

```
header('X-Accel-Buffering: no');
echo 'hello';
flush();
ob_flush();
sleep(1);
echo 'world';

```


# hhvm 
hhvm本身支持HTTP 1.1，但实际测试并没有效果，经过hhvm小组的诊断，需要修改ORP Runtime Webserver配置：

```
fastcgi_param HTTP_VERSION 1.1;

```

备注：在实践中，我并没有在nginx的配置里面加上这个参数配置，一样可以实现分段输出。也许是跟hhvm版本相关，这里并未进一步求证。

# gzip
能够正常支持gzip。


# 文章来源
转载于@David Zhang贴吧bigpipe迁移技术文档，本人加了些实践备注。
