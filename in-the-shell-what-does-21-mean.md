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

输出分**标准输出(standard output)**与**标准错误（standard error）**。在Unix系统中, [任何东西都是文件](https://en.wikipedia.org/wiki/Everything_is_a_file)，包括标准输出和标准错误。任何打开的文件都有一个**文件描述符**与之对应，你可以理解为每个打开的文件分配了一个id,操作文件只需要操作与之对应的id就行了。**标准输出的文件描述符为`1`,标准错误的文件描述符为`2`**

先前的脚本
```
$ cat foot.txt > output.txt
```
等同于

```
$ cat foot.txt 1> output.txt

```
只是将标准输出定向到了output.txt中，**而标准错误并没有**定向到output.txt中。

脚本
```
$ cat foot.txt > output.txt
cat: foot.txt: No such file or directory
```
在文件不存在时，想要把信息定向到output.txt，应该改为

```
$ cat foot.txt 2> output.txt
```

# 2>&1

既想把标准输出和标准错误都定向到output.txt文件，这时你就得这么写了

```
$ cat foot.txt >output.txt 2>&1
```

**它表示现将标准输出定向到文件output.txt中，然后将标准错误定向到标准输出中**，等同于将标准输出和标准错误一同输出到output.txt文件中。&1 表示标准输出，多个&符号是因为脚本解析问题，试想

```
$ cat foot.txt >output.txt 2>1
```
代表把标准错误定向到**文件1**中，**并非标准输出**中。


# 其它问题
## 将 2>&1 放到前面
```
$ cat foot.txt 2>&1 >output.txt

```
这样是不行的，这代表将标准错误定向到标准输出中（注意，此时的标准输出为命令行屏幕，所以标准错误定向到了命令行屏幕），再将标准输出定向到output.txt中，**然而标准错误被定向到了命令行屏幕**，这并非所期望的。
当文件foot.txt不存在时，你会看到
```
$ cat foot.txt 2>&1 >output.txt
cat: foot.txt: No such file or directory
```

## 另一种写法

你也可以另外一种写法，也能同时将标准输出和标准错误同时定向到某个文件

```
$ cat foot.txt &>output.txt

```
但是这仅仅是bash的扩展，并非一种标准的shell写法。如果你想你的shell脚本有较高的跨平台性，最好不要使用这种方式。

## 效率问题
你还可以这种写法，也能同时将标准输出和标准错误同时定向到某个文件
```
$ cat foot.txt 1>out.txt 2>out.txt

```
但是这种打开了两次文件foot.txt, 而且结果还会相互覆盖。