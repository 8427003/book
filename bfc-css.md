# 背景
BFC(Block Formatting Contexts), 这东西在css里经常被谈论到。它是一个非常抽象的概念，难以让人理解。这里谈谈我个人的看法。

# BFC vs 盒子模型

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

说得通俗点就是，一个盒子的大小，你可以从外面量，你也可以从里面量来说明一个盒子有多大。只要大家都认同就行，只是标准不一样而已。**盒子模型更多多在意的是盒子本身属性的问题。**