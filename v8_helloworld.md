# 背景

v8引擎跟前端所用javascript语言密切相关。学习它有助于以后对node，以及浏览器内核学习。

官方地址：https://developers.google.com/v8/

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

参考：

include 文件目录结构如下：

```
├── libplatform
│ └── libplatform.h
├── v8-debug.h
├── v8-experimental.h
├── v8-platform.h
├── v8-profiler.h
├── v8-testing.h
├── v8-util.h
├── v8-version.h
├── v8.h
└── v8config.h
```

build 后native目录结构如下：

```
├── cctest
├── d8
├── generate-bytecode-expectations
├── hello-world
├── icudtl.dat
├── libfuzzer_support.a
├── libgmock.a
├── libgtest.a
├── libicui18n.dylib
├── libicuuc.dylib
├── libjson_fuzzer_lib.a
├── libparser_fuzzer_lib.a
├── libregexp_fuzzer_lib.a
├── libv8.dylib
├── libv8_base.a
├── libv8_libbase.a
├── libv8_libplatform.a
├── libv8_libsampler.a
├── libv8_nosnapshot.a
├── libwasm_asmjs_fuzzer_lib.a
├── libwasm_fuzzer_lib.a
├── obj
├── obj.host
├── obj.target
├── process
├── unittests
├── v8_shell
├── v8_simple_json_fuzzer
├── v8_simple_parser_fuzzer
├── v8_simple_regexp_fuzzer
├── v8_simple_wasm_asmjs_fuzzer
└── v8_simple_wasm_fuzzer
```


## 4.编译helloworld

```
g++ -I./include hello_world.cpp -o helloworld -L./out/native -lv8 -lv8_libbase -lv8_libplatform

说明：
-I./include 指明头文件所在目录
-L./out/native 指明链接库根目录
-lv8 指明libv8.dylib v8动态链接库
-lv8_libbase 指明libv8_libbase.a
-lv8_libplatform 指明libv8_libplatform.a
```

注意：

1、libv8_libplatform.a 这个静态库在新版本的v8使用时是必须要的
这个库依赖libv8_libbase.a，所以二者都必须有。很多时候死在了这两个库没加上。

2、头文件include/libplatform/libplatform.h 里面代码依赖v8-platform.h需要改为正确的路径

```
#include "v8-platform.h" 
改为：
#include "../v8-platform.h"
```








