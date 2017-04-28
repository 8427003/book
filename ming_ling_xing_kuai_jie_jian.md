## 说明

我们通常会在命令行作频繁的操作，每少敲击一个字符，也可以提高大的效率。它太频繁了，所以我们要总结。命令行下的键位与emacs的键位相同。不必追求炫酷的快捷键，最基础的练好就是最好的。

```
注：
  c - ctrl
  m - alt/option
  向前-从左到右
  向后-从右到左
```

### 1. 移动

```
c + f 向前移一个字符
c + b 向后移一个字符

m + f 向前移一个单词
m + b 向后移一个单词

m + a 移动到行首
m + e 移动到行尾
```

### 2. 删除

```
c + d 向前删除一个字符
c + h 向后删除一个字符
c + 8 同 c + h


m + d 向前删除一个单词
c + w 向后删除一个单词

m + w 删除到行首（从当前光标,zsh支持）
c + k 删除到行尾（从当前光标）

c + u 删除整行(zsh删除整行，bash从当前光标删除到行首）
```

### 3. 修改

```
c + t 光标当前字符与后一个字符替换
m + t 光标当前单词与后一个单词替换

m + c 从光标处单词更改为首字母大写的单词
m + u 从光标处单词更改为全部大写的单词

c + xx: Move between the beginning of the line and the current position of the cursor. 
This allows you to press Ctrl+XX to return to the start of the line, change something, 
and then press Ctrl+XX to go back to your original cursor position. To use this shortcut, 
hold the Ctrl key and tap the X key twice.

^abc­^­def   Run previous command, replacing abc with def
```

### 4. 剪切粘贴

```
* Ctrl+W: Cut the word before the cursor, adding it to the clipboard.
* Ctrl+K: Cut the part of the line after the cursor, adding it to the clipboard.
* Ctrl+U: Cut the part of the line before the cursor, adding it to the clipboard.
* Ctrl+Y: Paste the last thing you cut from the clipboard. The y here stands for “yank”.
```

### 5. 查找

```
c + s + '字符' 向前查找（zsh支持） c+j 去修改
c + r + '字符' 向后查找 c+j 去修改
c + p 上一个命令
c + n 下一条
```

### 6. 回撤

```
c + x, 然后u
c + _ 
c + 7
```

### 7. 特殊符号

```
!*   All arguments of previous command
!$ 最后一个参数
c + . 最后一个参数

!abc   Run last command starting with abc
!!   Repeat last command
```

### 8. 其它常用

    c + q 或者 m + q 删除当前，当执行下一条命令后，自动粘贴到命令行（zsh支持）

    c + - 当前目录与先前的目录相互切换

    给命令加注释  ls #xxxx,   ctrl+r 搜索注释

    #ls 不执行此条命令(同c + a 给注释）

    先导入环境变量export EDITOR=vim 然后 c-x c-e 编辑超长命令

    top命令，防止丢失session

    mac 打开`sudo visudo`文件改sudo不要密码

    set -o vi  Set Emacs Mode in bash:  set -o emacs 更改命令行键位规则 

    ls **/*.js (zsh) 列出js文件

    cd - tabtab 历史(zsh)

    修改  r lg=lg (zsh)

### 9. 高效tab 切换

```
传统方式 commond + tab (mac)

其它方式1：给app编固有顺序 https://manico.im/

其它方式2：Alfred

给当前应用指定输入法，比如切换到微信使用中文，切换到iterm2 使用英文：keyboard pilot

```

### 10.  命令行不可或缺神器

```
tldr 命令行使用sample。

autojump (oh-my-zsh z 插件）一步到位cd到目录。 比如有一个这样的目录~/git/aaa/bbb/ccc,一步跳到ccc目录：autojump ccc
```

### 11.  iterm2针对ssh密码管理

```
triggers 配置如下:

Regular Expression            Action                 Parametes                      Instant
#dev                          Send Text              ssh dev@css3.io\r              no check
ssh dev@css3.io               Open Password Manager  dev(去passwd manager添加dev密码）check


测试命令：
#dev

```



