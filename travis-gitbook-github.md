#背景

[gitbook](https://www.gitbook.com/)既是一个网站，专业提供写书的地方服务。也是一个基于node平台的应用，可以生产静blog。然而它作为网站，提供了在线访问的服务，这是我用gitbook生成的静态blog：http://www.css3.io

做一个这样的blog很容易，类似于github创建一个源，blog就自己生成了，自定义域名也支持。如果觉得gitbook不靠谱，还可以将源码托管到github,然后通过github的webhooks关联到gitbook，去gitbook设置项看一下就懂怎么操作了，都不用文档。最后直接提交代码到github就会触发webhooks，gitbook就会生成静态blog了，相当简单。

但是有个问题，**gitbook托管的静态blog访问速度没有github的[GitHub Pages](https://pages.github.com/)快**，有时候10s左右都没响应，确实蛋疼。于是乎不用gitbook提供的在线访问服务了，直接用它生成静态blog，然后用github pages来支持在线访问，但又想跟使用gitbook一样方便。这个时候travis派上用场了。




