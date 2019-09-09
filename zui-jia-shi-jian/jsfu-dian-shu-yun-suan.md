# 浮点数精确度问题

背景：javascript的世界里`0.1 + 0.2 = 0.30000000000000004`而你期望的是`0.1 + 0.2 = 0.3` 



**这个小小的问题目前只能用第三方库来处理**：

[http://mathjs.org/examples/browser/old\_browsers.html.html](http://mathjs.org/examples/browser/old_browsers.html.html)  
\(缺点：不兼容老的浏览器，如果需要兼容，必须引入es5-shim，有点大113k，优点：但是文档分类清晰，可自行组装模块）

[http://mikemcl.github.io/decimal.js/\#decimal](http://mikemcl.github.io/decimal.js/#decimal)  
（缺点，不可组装，star 少于mathjs在github，优点：兼容js1.3, 只有25k）

