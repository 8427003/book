# 模块化requirejs vs  seajs


#### 模块名与打包的关系
先说requirejs
已知，requirejs定义一个模块语法如下
```
define("foo/title", ["my/cart", "my/inventory"], function(cart, inventory) {
    //Define foo/title object in here.
});
```

其中，第一个参数（模块名）可以参略。省略后的模块名会以文件路径命名。
问题来了，如果一个文件里面定义了两个模块，这个时候省略第一个参数是不行的。因为不可能两个模块都叫同样的模块名（文件路径）。
这就跟打包情况一样了，因为打包本质是把所有文件内容合并到一个。因此requirejs的打包必须依赖一个叫r.js（在项目bin文件夹中），这个工具的目的是，如果遇到没有显示写模块名的定义函数，就在构建的时候以文件名作为第一个参数加上去。

seajs问题更大，我们来看语法先
```
define(id?, deps?, factory)

define('hello', ['jquery'], function(require, exports, module) {
  // 模块代码
});
```
一般情况下，我们不写第一参数。会遇到与requirejs一样打包问题。seajs我们一般也不写第二个参数，因为可以通过require关键字达到一样的效果。
这里就比较坑了。如果模块代码通过require来申明依赖，那么只有在运行时通过Function.toString()然后正则提取关键字require来静态分析获取依赖。我们通常要对代码进行优化混淆，require关键字通常会被以更短的变量名替换。所以seajs在这种情况下，一定要保留require关键字，不能给它整没了。解决方案有两种，1.在混淆的时候避开关键字require   uglifyjs支持 --reserved 'require'  参数。2. spm3(https://github.com/seajs/seajs/issues/538), 来预提取require，然后把提取的依赖放到第二个参数（就tm跟requirejs的语法一样了）。具体可参见为什么要有约定和构建工具https://github.com/seajs/seajs/issues/426。
**
以依赖jquery为例子，requirejs 与seajs区别**
require 语法
```
define("foo/title", ["jquery"], function($) {
    //Define foo/title object in here.
});
```
seajs 语法：
```
define(id?, deps?, factory)
define('hello', ['jquery'], function(require, exports, module) {
  // 模块代码
});
```
注意我们一般不写第二个参数。用require关键代替。
```
define('hello', function(require, exports, module) {
	require(‘jquery’);
  // 模块代码
});
```
如果在不打包成一个文件的情况下。
两个文件在执行定义模块代码时，都会去下载依赖文件（如果没有下载过）。区别在于
执行模块代码阶段时，requirejs通过第二个参数知道依赖文件，下载依赖文件，然后实例化全部依赖模块。再执行模块代码。seajs是通过Function.toString()然后正则提取关键字require来静态分析获取依赖文件的，下载依赖文件。再执行模块代码，然后当执行到require关键字时才实例化依赖模块。

#### 总结：
两个工具在构建的时候都需要依赖自身配套的打包工具来解决模块id问题，这一点比较坑。seajs 更需要对require关键字构建时保留，这点更坑。当然这两点是目前解决不了的业务场景。对于两种规范下，懒执行好（seajs），还是预执行好（requirejs）不作评论。这是个哲学问题。因为目前两种方式都有很好的实践，如果java就是预执行，nodejs就是懒执行。懒执行涉及到代码回滚问题，比如依赖的模块异常了，那么已经执行的代码需要回滚吗。当然预执行也有问题，在程序运行初期会有性能浪费问题，执行了没必要执行的代码。


#### 对模块的理解

模块实际上解决的是 全局污染的问题 和 依赖顺序问题。


1.要解决【全局污染的问题】  最简单的方式是 一个命明空间比如
```
xx = {
	xxx,xxx
}
```

2.要解决【依赖顺序问题】得用更复杂的wapper，比如requirejs的
```
define（[], callback)
```
3.还有背后的一些哲学问题，比如 cmd vs amd。是预执行好，还是懒执行好。java 预先加载，nodejs懒加载。
预加载和运行时动态加载各有利弊。从标准发展看，更倾向于预加载。这可以做更多的事情。比如tree-sharking。


# 参考
http://www.sohu.com/a/129975875_495695
umd
https://segmentfault.com/a/1190000004873947

requirejs  VS seajs
https://div.io/topic/439
https://www.zhihu.com/question/20342350




