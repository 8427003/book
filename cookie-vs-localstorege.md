cookie vs  localstorege

1. 存储空间
    1. cookie有以下3方面大小限制。a.每个域名即cookie键值对数量限制，小的只有20-50个，如ie6.7。大的有600个。b.每个键值对大小有限制，小的4k左右。c.每个域名下，整体cookie容量有限制，小的只有4k。如ie。具体见表  http://browsercookielimits.squawky.net/  
    2. localstorage  5M
2. 与后端通信
    1. 传输量，cookie 每个请求都携带cookie，localStorage不会
    2. 安全性隐私，cookie 可以http only  可用用来作用户登陆验证
3. 生命周期
    1. cookie可设置过期时间
    2. localstoge不可设置，sessionStorage有自己的类似session的周期，关闭tab消失。
4. 兼容性
    1. localStorage ie>=8.  ie6.7可用user data（貌似1m，比起4k还是比较多了）代替，基本上local不行都用cookie 作为降级处理。具体使用可参考http://msdn.microsoft.com/en-us/library/ms531424(VS.85).aspx, https://msdn.microsoft.com/en-us/library/ms533007(v=vs.85).aspx， http://www.javascriptkit.com/javatutors/domstorage2.shtml
5. 易用性
    1. cookie 需要封装，localStorage 有较好的api使用。他们的键值都只能是string，其它数据类型会隐式转型。所以存放时一般都JSON.stringify.取数据时，JSON.parse解开。
    2. cookie 父子域名间可共享数据，而且比较复杂, 比如host-only（父亲设置一个host-only，子是不可读的），以及域名是否前面有一个点（在老的规范中前面有一个点表示子域名可读，没有表示当前域名可读https://stackoverflow.com/questions/18492576/share-cookie-between-subdomain-and-domain）。https://stackoverflow.com/questions/12387338/what-is-a-host-only-cookie参见 
    3. localStorage 严格同源策略


其它离线存储方案：
https://blog.csdn.net/u013063153/article/details/52458348

localstage使用注意事项

http://imweb.io/topic/5590a443fbb23aae3d5e450a


fileSystem
https://www.html5rocks.com/zh/tutorials/file/filesystem/