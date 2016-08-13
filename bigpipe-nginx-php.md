# php实现分段输出demo

最简单demo：
```
echo 'hello';
flush();
ob_flush();
sleep(1);
echo 'world';
```
这是一个最简单的BigPipe demo，然而由于fastcgi_buffer的存在，并不能看到分段输出的效果。那么，我们把程序进行一下改动，用str_pad填充一些字符以达到buffer。

改进后demo：
```
echo str_pad('hello', 10000, ' ');
flush();
ob_flush();
sleep(1);
echo str_pad('world', 10000, ' ');
```
进行字符填充后，BigPipe效果显现了出来，hello之后过1秒后会才会出现world。

#nginx
Nginx对于网络请求会通过buffer进行优化，在反向代理层有proxy_buffer，在fastcgi层有fastcgi_buffer。
由于buffer的存在，如果包比较小的话BigPipe的chunked输出很可能会被buffer住。针对这种情况，一般来说有三种方式。


