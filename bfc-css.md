# 背景
BFC(Block Formatting Contexts), 这东西在css里经常被谈论到。它的难点在于，它是一个非常抽象的概念，难以让人理解。还容易与盒模型区分不开。反而如何触发它，或者它有什么使用场景倒还容易理解。这不是一篇讨论它具体细节的文章。这里只是谈谈我个人对这个抽象概念的理解。

# 盒子模型

最常用盒子模型
* content-box
* border-box

**不同的属性意味着对大小的计算不同**

* content-box

    width = 内容的宽度

    height = 内容高度

* border-box
    
    width = border + padding + 内容的宽度
    
    height = border + padding + 内容的高度

说得通俗点就是，一个盒子的大小，你可以从外面量，你也可以从里面量来说明一个盒子有多大。只要大家都认同就行，只是标准不一样而已。**盒子模型更多在意的是盒子本身属性的问题。**

# BFC
Block Formatting Contexts，我们先理解什么是`Formatting Contexts`。

`Formatting`格式化，啥意思，有用编辑器格式化代码过没？就是让代码的样子好看点。通过英文查询，你会发现format其实指的是**排列**的意思。所以`Formatting`代表了怎么去排列，专业点理解为布局，layout的方式, 或显示的位置。

`Contexts` 代码里面有过这个单词吧-上下文。上下文是个啥东西，在程序里我们是通常用来放东西的，一段程序往里面放，一段程序从里面取，其它地方还取不到。可以理解为容器或者一个限定范围。
另外举个例子，语文里经常说的，请你联系上下文说下这个词什么意思。
比如某人说了一句 “漂亮”，让你联系上下问想下，漂亮指的啥。这个时候你就得在出现“漂亮”一词的附近句子或者段落中寻找一些其它信息，比如说的是一件事儿，那么漂亮意思是这事儿做得好。说的如果是某个人的样子，那么漂亮就是这个人是个美女...
那么在我们css里可以理解为**一块区域，表示一个限定范围，表示一个装元素的容器**。

**
`Formatting Contexts` 合一起，就代表一块限定区域内如果去排列布局里面的东西，即格式化上下文。**


`Block`就好理解了，管你是胖的、瘦的，还是长的、圆的，或者是块级的、行内的。仅仅代表针对不类型元素的规则不同，块级元素有块级规则，内联元素有内联规则。

# 总结

最后，`Block Formatting Contexts` 在css中我理解为，在一个限定范围，范围内的元素，或者内容，如何布局排列的一个规则名称。

它与盒子模型概念的区别在于盒子模型更多强调这个盒子本身的属性计算的规则，而`Block Formatting Contexts`强调在一个局部范围、盒子里面，或者盒子之间的一个布局或者位置计算的规则。

# 参考

http://rainey.space/2016/07/02/Ni_Zhen_De_Liao_Jie_He_Mo_Xing_Ma/

http://www.cnblogs.com/WebShare-hilda/p/4700682.html

https://xinranliu.me/2012-10-21-what-is-block-formatting-context/

https://developer.mozilla.org/zh-CN/docs/Web/Guide/CSS/Visual_formatting_model

https://www.sitepoint.com/understanding-block-formatting-contexts-in-css/

http://alexbai1991.github.io/2015/03/27/cssbfc/

