# 背景

在 webpack中看到了两个关键字，commonjs 和 commonjs2. 它们与模块导出有着密切关系。

# commonjs vs commonjs2 vs exports vs module.exports

CommonJs spec defines only exports. But module.exports is used by node.js and many other CommonJs implementations.

commonjs mean pure CommonJs

commonjs2 also includes the module.exports stuff.

这里引用了 https://github.com/webpack/webpack/issues/1114 的回答，commonjs vs commonjs2 这两个概念问题迎刃而解。

那到底**module.exports vs exports** 区别是什么呢？

个人看了很多文章，任然懵，觉得这篇文章https://www.sitepoint.com/understanding-module-exports-exports-node-js/ 解释得比较到位。

**理解关键点**

1. **require** 大致实现：

    ```
        var require = function(path) { 
            // ... 
            return module.exports; 
        };

    ```
2. module.exports => {} <= exports 指向同一个对象。 两者最好不要同时使用。

    ```
    // exports 仅适用于：
  
    exports.a = 'xxx';
    
    // module.exports 适用于
    
    module.exports = 'xxx';
    module.exports.a = 'xxx';
    ```
    **我又产生了一个疑问，exports 看起来是多余的。它所能做的，module.exports都能实现。**

3. 其实**2中的疑问**一点也没错，nodejs 官方文档中提及https://nodejs.org/docs/latest/api/modules.html#modules_exports_alias
  **exports** 只是**module.exports**的一个**别名** 还提示当你搞不清楚的时候，就用module.exports。

# 总结

1. commonjs 规范只定义了exports，而 module.exports是nodejs对commonjs的实现，实现往往会在满足规范前提下作些扩展，我们这里把这种实现称为了commonjs2.

2. module.exports 是nodejs对commonjs的具体实现。exports 只是它的一个别名。搞不清楚关系的时候可以不用这个别名。


# 参考

https://www.sitepoint.com/understanding-module-exports-exports-node-js/

https://nodejs.org/docs/latest/api/modules.html#modules_exports_alias

https://github.com/webpack/webpack/issues/1114






