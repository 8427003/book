# 背景

Shell脚本中经常看到有人这么写

```
ls foo > /dev/null 2>&1
```

# 快速理解i/o重定向

我们使用`cat`命令，默认地将在屏幕看到如下输出

```
$ cat foo.txt
hello world

```
我们也可以用**`>`符号**将输出结果定向到另外的地方去，这就是**i/o重定向**


```
$ cat foot.txt > output.txt
```
当然，看到这样的结果必须是执行脚本没有任何的错误，假如foot.txt文件不存在，你将会看到这样

```
$ cat foot.txt > output.txt
cat: foot.txt: No such file or directory
```
结果并没有输出到`output.txt`文件，这是为什么呢？

# 文件描述符

输出分**标准输出(standard output)**与**标准错误（standard error）**。在Unix系统中, [任何东西都是文件](https://en.wikipedia.org/wiki/Everything_is_a_file)，包括标准输出和标准错误。任何打开的文件都有一个**文件描述符**与之对应，你可以理解为每个打开的文件分配了一个id,操作文件只需要操作与之对应的id就行了。标准输出的文件描述符为`1`,标准错误的文件描述符为`2`


