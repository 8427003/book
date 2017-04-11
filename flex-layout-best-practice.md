# 背景

在前端布局这块儿 [CSS Flexible Box Layout](https://www.w3.org/TR/css-flexbox-1/) 使用得相当广泛了。但是这个css属性并非想象的那么简单，它有3个大版本的语法规范，这导致了我们在实际使用中不知道使用哪个版本。

有文章指出，我们混合三个版本来实现更多浏览器兼容性（更多参考https://css-tricks.com/using-flexbox/\)。但是这种方案在实践中使用起来并不太友好。

1.我们手动写三种版本，太复杂，如下

```css
.flexbox { 
    display: -webkit-box; 
    display: -webkit-flex; 
    display: -moz-flex; 
    display: -ms-flexbox; 
    display: flex; 
}
```

2.当然我们可以使用sass库。

比如https://github.com/mastastealth/sass-flex-mixin，或者优秀的compass  http://compass-style.org/reference/compass/css3/flexbox/。但是我理解不是所有的人都喜欢使用一个库来解决问题，也不是所有人都喜欢使用sass（像我这样更喜less的人就比较迷茫，当然less库也有，但是我没找到一star比较高的）

# 期望

有没有不依赖库，能够像用一般的css属性一样使用flex布局。答案当然是有的，只是你必须对flex语法的三个版本充分理解，尤其是每个版本对应的浏览器兼容性。

#### 理解三个版本

打开标准  https://www.w3.org/TR/css-flexbox-1/

```
This version:
http://www.w3.org/TR/2016/CR-css-flexbox-1-20160526/

Previous Versions:
http://www.w3.org/TR/2016/CR-css-flexbox-1-20160301/
http://www.w3.org/TR/2015/WD-css-flexbox-1-20150514/
http://www.w3.org/TR/2014/WD-css-flexbox-1-20140925/
http://www.w3.org/TR/2014/WD-css-flexbox-1-20140325/
http://www.w3.org/TR/2012/CR-css3-flexbox-20120918/
http://www.w3.org/TR/2012/WD-css3-flexbox-20120612/（2012年 diplay:flex)
http://www.w3.org/TR/2012/WD-css3-flexbox-20120322/
http://www.w3.org/TR/2011/WD-css3-flexbox-20111129/
http://www.w3.org/TR/2011/WD-css3-flexbox-20110322/（2011年 display: flexbox)
http://www.w3.org/TR/2009/WD-css3-flexbox-20090723/ （2009年 display: box）
```

网络上大多数文章将flex分为了2009， 2011， 2012年三个版本，它们分别的代表属性为

```css
.flexbox { 
    display: -webkit-box; /**2009 年 **／
    display: -ms-flexbox; /**2011 年 **／
    display: flex; /**2012 年 **／
}
```

与w3c文档还是比较吻合的，这里注意按年分划分的版本在w3c文档里对应**开始提出的年份**，比如

```
http://www.w3.org/TR/2012/WD-css3-flexbox-20120322/
```

这个版本是2012年提出的，它实际是`display: flexbox `的最后一个版本。并非指的是`diplay:flex` 之所以我们要提这个点，是因为你看到2012年字眼的时候，一定要认清楚，到底说的是 `display: flexbox` 还是 `display: flex` \( [canuse notes 2 Only supports the 2012 syntax\)](https://caniuse.com/#search=flex)  这里指的是 `display: flexbox` 稍后我们谈兼容性是详细说明）

### 兼容性

https://caniuse.com/\#search=flex     import china数据 可以看到如下notes

```
Most partial support refers to supporting an older version of the specification or an older syntax.
1 Only supports the old flexbox specification and does not support wrapping.
2 Only supports the 2012 syntax
4 Partial support is due to large amount of bugs present (see known issues)
```

这里的 notes1 中的old flexbox指的是2009年的版本`display: -webkit-box`，notes2 指的是2011年的 `display: flexbox` 版本

### **结论**

我们从caniuse中分析出兼容性

1.2011年版本基本只有ie10支持，并且必须带-ms-前缀, ie9以及更老的不支持flex布局

2.chrome 只支持2009年版本（带前缀）以及最新的2012年版本

3.android 火狐, ios

