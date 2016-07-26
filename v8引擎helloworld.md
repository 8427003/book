# 背景

v8引擎跟前端所用javascript语言密切相关。学习它有助于以后对node，以及浏览器内核学习。

# 目标

从编译源码到运行helloworld    

# 实战记录

## 1.安装 depot_tools

这个工具是用来管理v8源码以及依赖的，把它的角色理解为包管理。因为v8的依赖很多，可能采用不同的源码版本管理方式，以及其它比较复杂的情况。很难用一些简单的现成的项目来管理依赖。于是乎就搞了这个。（纯属个人的理解）

官方地址：http://dev.chromium.org/developers/how-tos/install-depot-tools

## 2.下载v8源码

```
1.gclient (非必须,为了更新gclient工具本身）
2.fetch v8

也可这样:
1.mkdir v8
2.cd v8
3.gclient config https://chromium.googlesource.com/v8/v8
4.gclient sync
```
## 3.源码build

```
make native -j4 library=shared snapshot=off

说明：
这里编译为了动态链接库。这个点比较重要。
在mac上会得到一个libv8.dylib文件,linux是libv8.so.
-j4 表示用4个线程来编译
library=shared 表示编译成动态链接库
snapshot=off 会编译快一点

更多参数请参照：https://github.com/v8/v8/wiki/Building%20with%20Gyp
```

## 4.编译helloworld

```
g++ -I./include hello_world.cpp -o helloworld -L./out/native -pthread -lv8 -lv8_libbase -lv8_libplatform


```