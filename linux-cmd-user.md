# User



## **useradd** _选项_ _用户名_

选项：

```
-c comment 指定一段注释性描述。
-d 目录 指定用户主目录，如果此目录不存在，则同时使用-m选项，可以创建主目录。
-g 用户组 指定用户所属的用户组。
-G 用户组，用户组 指定用户所属的附加组。
-s Shell文件 指定用户的登录Shell。
-u 用户号 指定用户的用户号，如果同时有-o选项，则可以重复使用其他用户的标识号。

```

例子1：

```
useradd –d /usr/sam -m sam
```
此命令创建了一个用户sam，
其中-d和-m选项用来为登录名sam产生一个主目录/usr/sam（/usr为默认的用户主目录所在的父目录）。

例子2：

```
useradd -s /bin/sh -g group –G adm,root gem
```
此命令新建了一个用户gem，该用户的登录Shell是/bin/sh，
它属于group用户组，同时又属于adm和root用户组，其中group用户组是其主组。

---

## **userdel** _选项_ _用户名_

常用的选项: -r，它的作用是把用户的主目录一起删除。

例子：

```
userdel -r sam
```
此命令删除用户sam在系统文件中（主要是/etc/passwd, /etc/shadow, /etc/group等）的记录，同时删除用户的主目录。


---

## **usermod** 选项 用户名

选项同useradd

例子:

```
usermod -s /bin/ksh -d /home/z –g developer sam

```
此命令将用户sam的登录Shell修改为ksh，主目录改为/home/z，用户组改为developer。

---

## 查询

当前登陆用户:
```
> w
> who
```
查看自己的用户名
```
> whoami
```
查看用户信息
```
> finger root
> id root

```
查看用户登陆记录
```
> last #查看登录成功的用户记录
> lastb #查看登录不成功的用户记录
```
查看所有用户
```
> cut -d : -f 1 /etc/passwd
> cat /etc/passwd |awk -F \: '{print $1}'
```