# bigpipe vs 静态页面

要想网页响应速度快，其实最简单可行的方法是将它生成静态页面就好了。但是有些页面不适合生成静态页面：比如首页，或者列表页，以及那些数据在实时变化的页面。像某个产品的详情页这种就适合生成静态页面，因为数据很少更新。所以对于那种不适合用生成静态页面来解决的场景我们怎么办呢？maybe bigpipe能派上用场。

# bigpipe 解决了什么问题

衡量一个页面的性能，其中一个重要指标，是这个页面“白屏”时间。这与yehoo的优化建议

```
Flush the Buffer Early
When users request a page, it can take anywhere from 200 to 500ms for the backend server to stitch together the HTML page. During this time, the browser is idle as it waits for the data to arrive. In PHP you have the function flush(). It allows you to send your partially ready HTML response to the browser so that the browser can start fetching components while your backend is busy with the rest of the HTML page. The benefit is mainly seen on busy backends or light frontends.

```