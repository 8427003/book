# php实现分块输出最简单demo

```
echo 'hello';
flush();
ob_flush();
sleep(1);
echo 'world';
```