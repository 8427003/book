# linux 系统调优

## 背景

我们在使用阿里云slb后，健康检查老是报错。我的qps 最高时有170左右，15分钟内的接口访问次数大概10万次。经过和阿里云工单沟通，可能是我们系统未调优所致。

## 建议调优参数

这是阿里云给我们的调优清单

```
net.ipv4.tcp_syncookies = 1
net.core.somaxconn = 4096
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.netfilter.nf_conntrack_max = 655350
net.netfilter.nf_conntrack_tcp_timeout_established = 1200
net.ipv4.ip_local_port_range = 1024 60999
tcp_timestamps = 1
tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
```

## 最重要的`net.core.somaxconn`

理解这个参数前，我们先简单理解下tcp协议。

#### tcp是操作系统帮我们维护的

非用户程序维护。这个概念非常重要。举个以前同事考我的例子，问浏览器访问一个请求时，与服务器建立了一个连接，此时肯定打开了一个套接字，此时浏览器突然崩溃，或者被手动暴力结束进程。那这个套接字有没有被关闭？如果你回答，没有关闭。那与答案不符合。你也许会错误以为浏览器进程突然地被杀死，还没有来得及关闭套接字。其实这个套接字会被操作系统关闭。用户进程死掉，操作系统肯定知道，而且这个tcp套接字就是系统维护的，系统有的是机会来关闭它。

#### Linux 网络半链接、链接队列

这里与somaxconn相关的有两个队列。当tcp 三次握手时, 我们以浏览器访问请求为例子。当浏览器发起一个请求时，会发生系统调用，要求与服务端建立tcp 连接。client 发送一个sync包，服务器接收到这个包后，会回应一个ack+sync包，同时将这个连接放到一个队列里\(SYN半连接队列）。当服务端又收到来自client的ack时，会把这个连接从半连接队列拿出来，放到accept队列里。注意这里服务端所有的动作都是服务端操作系统内核完成的，跟用户程序没关系。后面我们有代码表达这块儿更清晰。先记住这里有两个队列。

**syn半连接队列溢出**  
既然是队列就一定有大小，你一定听过**TCP SYN flood洪水攻击**，原理很简单。就是client 发sync 包后，不再响应ack 包。那么syn半连接队列就会被填满。如何解决？调大`tcp_max_syn_backlog`， 这种方法治标不治本。还有一种调整系统参数`tcp_syncookies=1`.一般情况下，这个系统参数默认会被开启。开启后收到client的sync就不把连接放到syn半连接队列里了，而是类似浏览器cookie原理，给这个连接种个标记，当收到ack时检查有没有这种标记，有就直接放到accept队列。具体细节可参考其它文章，这里不展开。如果你想确定下是否开起，以centos 为例，可以使用查看。

```
cat /proc/sys/net/ipv4/tcp_syncookies //1-开启
cat /proc/sys/net/ipv4/tcp_max_syn_backlog
```

由于tcp\_syncookies一般情况下默认打开，所以我们也不太关注这个队列状态。

**accept全接队列溢出**

查看这个队列大小

```
# 查看
cat /proc/sys/net/core/somaxconn 
# 修改
sysctl -w net.core.somaxconn=1024 或 echo 1024 > /proc/sys/net/core/somaxconn
```

如果你是容器，你一定要注意了，得去容器里面查看或修改。  
修改完了系统参数也不一定你的队列就这么大了。因为在用户层还可以控制，就是new Socket的时候，一般会有一个`backlog` 参数。`backlog`的值与系统参数取小的一个作为真实的队列值。一般情况下，nginx=511，nodejs=511，tomact=100。但是系统somaxconn默认为128，如果你不调整的话，很大概率你的队列最大值为128或100。

**确定生效**  
另外，一般情况下，你设置了需要重启应用才会生效。那如何检验这个队列最大值是否成功设置呢？

```
ss -lnt

State      Recv-Q Send-Q Local Address:Port               Peer Address:Port
LISTEN     0      128          *:443                      *:*
LISTEN     0      1      127.0.0.1:32000                    *:*
LISTEN     0      128          *:80                       *:*
LISTEN     0      128          *:22                       *:*
LISTEN     0      128    172.17.40.192:10010                    *:*
LISTEN     0      128         :::8219                    :::*
```

state 为listen的时候，Send-Q 为最大队列值，Recv-Q为当前队列中所有存在的连接。

**netstat 可能不是统计accept 全连接队列的工具**

```
netstat -na|grep ESTABLISHED

# 统计ESTABLISHED数量
# netstat -na|grep ESTABLISHED|wc -l 

tcp        0      0 172.17.40.192:443       223.64.133.155:46807    ESTABLISHED
tcp        0      0 172.17.40.192:443       182.125.40.131:19303    ESTABLISHED
tcp        0      0 172.17.40.192:443       119.250.226.12:26476    ESTABLISHED
tcp        0      0 172.17.40.192:443       117.59.84.9:40353       ESTABLISHED
tcp        0      0 172.17.40.192:443       117.178.12.241:11486    ESTABLISHED
```

注意：netstat ESTABLISHED 所统计的是 accept全连接的 + 已经被用户程序accept的总和。无法展示acept 全连接队列数量。具体分析看**用程序来解读accept全连接队列**

**用程序来解读accept全连接队列**

如果咱们应用程序不调用Accept函数，那么accept全连接队列就会随着连接的增多而溢出。这时候通过`ss -lnt`会发现Recv-Q 会不断增加。但是通过`netstat -na|grep ESTABLISHED` 会发现连接依然是ESTABLISHED状态。所以netstat 的ESTABLISHED 统计包括accept队列里的连接和已经被用户程序accept的连接。如果的真实环境中，发现Recv-Q 这个值不是0，并且趋近于Send-Q，说明你的应用程序负荷有点大了。当Recv-Q大于等于Send-Q时，你对连接将会被丢掉。反应到负载均衡，就是健康检查异常。

```
package main

import (
    "fmt"
    "net"
    "os"
    "time"
)

const (
    CONN_HOST = "0.0.0.0"
    CONN_PORT = "8080"
    CONN_TYPE = "tcp"
)

var count int
func main() {
    // Listen for incoming connections.
    l, err := net.Listen(CONN_TYPE, CONN_HOST+":"+CONN_PORT)
    if err != nil {
        fmt.Println("Error listening:", err.Error())
        os.Exit(1)
    }
    // Close the listener when the application closes.
    defer l.Close()
    fmt.Println("Listening on " + CONN_HOST + ":" + CONN_PORT)
    for {
        fmt.Println("reading===111111111111")
        time.Sleep(time.Duration(50)*time.Millisecond)
        fmt.Println("reading===2222222222222")
        // Listen for an incoming connection.
        conn, err := l.Accept()
        if err != nil {
            fmt.Println("Error accepting: ", err.Error())
            os.Exit(1)
        }
        // Handle connections in a new goroutine.
        go handleRequest(conn)
    }
}


// Handles incoming requests.
func handleRequest(conn net.Conn) {
        count++
    fmt.Println("reading===%d", count)
  // Make a buffer to hold incoming data.
  buf := make([]byte, 1024)
  // Read the incoming connection into the buffer.
  reqLen, err := conn.Read(buf)
  if err != nil {
    fmt.Println("Error reading:", err.Error(), reqLen)
  }
  // Send a response back to person contacting us.
  conn.Write([]byte("HTTP/1.1 200 OK\nContent-Type:application/json; charset=utf-8\nContent-Length:2\n\r\nok"))
  // Close the connection when you're done with it.
  //conn.Close()
}
```

# 总结

如果你的somaxconn设置有问题，你还可以通过查看，如果丢包多，很有可能是因为sommaxconn引起。当然具体原因得具体分析。

```
netstat -s | grep -E 'overflow|drop'

327 dropped because of missing route
502 ICMP packets dropped because they were out-of-window
204 ICMP packets dropped because socket was locked
22783 SYNs to LISTEN sockets dropped
```

另外比如协议栈的读写缓存大小也很重要, 不过我们没遇到，没有调整。

```
sysctl -w net.core.wmem_default=8388608
sysctl -w net.core.rmem_default=8388608
```

重要的是系统参数调整后，确保生效的手段，记住`ss -lnt` 命令。我们在实战中，就遇到了宿主机调了，容器没同步。容器同步了，应用没重启，应用本身backlog也需要调大这些坑。得清楚理解tcp是系统内核维护的，accept 这种系统调用对accept 全连接队列的影响等基本概念。

# 参考

TCP SYN flood洪水攻击原理和防御破解  
[https://www.cnblogs.com/sunsky303/p/11811097.html](https://www.cnblogs.com/sunsky303/p/11811097.html)

分析全队列，和半队列 具体分析  
[http://jm.taobao.org/2017/05/25/525-1/](http://jm.taobao.org/2017/05/25/525-1/)  
[https://cjting.me/2019/08/28/tcp-queue/](https://cjting.me/2019/08/28/tcp-queue/)

内核源码分析  
[https://my.oschina.net/moooofly/blog/666048](https://my.oschina.net/moooofly/blog/666048)

协议栈读写内存溢出  
[https://serverfault.com/questions/757305/what-does-syns-to-listen-sockets-dropped-from-netstat-s-mean](https://serverfault.com/questions/757305/what-does-syns-to-listen-sockets-dropped-from-netstat-s-mean)  
[https://www.cyberciti.biz/faq/linux-tcp-tuning/](https://www.cyberciti.biz/faq/linux-tcp-tuning/)

