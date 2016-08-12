# bigpipe vs 静态页面

要想网页响应速度快，其实最简单可行的方法是将它生成静态页面就好了。但是有些页面不适合生成静态页面：比如首页，或者列表页，以及那些数据在实时变化的页面。像某个产品的详情页这种就适合生成静态页面，因为数据很少更新。所以对于那种不适合用生成静态页面来解决的场景我们怎么办呢？maybe bigpipe能派上用场。

# bigpipe 解决了什么问题

衡量一个页面的性能，其中一个重要指标，是这个页面“白屏”时间。这与yahoo的优化建议```Flush the Buffer Early```有相似之处。其实我们用传统的web技术就能实现是这个优化：

```
echo "a";
sleep(1);
echo "b";
```

当server向client传递数据时，我们很容易让server先传字符“a",client渲染字符“a”，过一秒后，传递“b”时，再渲染“b”。并不需要server把字符“a”、“b”都收集完后才整个传递给client端，要知道等所有数据都收集完成，这个时间是很漫长的，client会一直处于白屏，client从来没这样要求过。在于开发者怎么优化了。

那为何还要bigpipe呢？虽然传统技术能优化这样的“白屏”时间问题。但是server能先传递字符“b”，再传递字符“a”么？显然不行。这样的话client渲染时数据“b”就在数据"a"前面了，渲染顺序就与逻辑期望的不一致了。bigpipe实现需要前后端结合，它能够灵活解决渲染顺序问题，甚至是优先级问题。

# bigpipe 与 Transfer-Encoding: chunked 什么关系？

# 参考

yahoo:Best Practices for Speeding Up Your Web Site
https://developer.yahoo.com/performance/rules.html
