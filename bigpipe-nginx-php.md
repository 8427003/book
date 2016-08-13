# php实现分段输出最简单demo

```
echo 'hello';
flush();
ob_flush();
sleep(1);
echo 'world';
```
这是一个最简单的BigPipe demo，然而由于fastcgi_buffer的存在，并不能看到分段输出的效果。那么，我们把程序进行一下改动，用str_pad填充一些字符以达到buffer。

```
echo str_pad('hello', 10000, ' ');
flush();
ob_flush();
sleep(1);
echo str_pad('world', 10000, ' ');
```