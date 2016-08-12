# bigpipe vs 静态页面

要想网页响应速度快，其实最简单可行的方法是将它生成静态页面就好了。但是有些页面不适合生成静态页面：比如首页，或者列表页，以及那些数据在实时变化的页面。像某个产品的详情页这种就适合生成静态页面，因为数据很少更新。所以对于那种不适合用生成静态页面来解决的场景我们怎么办呢？maybe bigpipe能派上用场。

# bigpipe 解决了什么问题

衡量一个页面的性能，其中一个重要指标，是这个页面“白屏”时间。这与yahoo的优化建议```Flush the Buffer Early```有相似之处。其实在传统的web实现技术中，我们已经这样干了。而且不需要任何的附加技术。

# 参考

yahoo:Best Practices for Speeding Up Your Web Site
https://developer.yahoo.com/performance/rules.html
