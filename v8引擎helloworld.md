# 背景

v8引擎跟前端所用javascript语言密切相关。学习它有助于以后对node，以及浏览器内核学习。

# 目标
    从编译源码到运行helloworld    

# 实战记录

## 1.安装 depot_tools

    这个工具是用来管理v8源码以及依赖的，把它的角色理解为包管理。因为v8的依赖很多，可能采用不同的源码版本管理方式，以及其它比较复杂的情况。很难用一些简单的现成的项目来管理依赖。于是乎就搞了这个。（纯属个人的理解）
    [depot_tools](http://dev.chromium.org/developers/how-tos/install-depot-tools);
##