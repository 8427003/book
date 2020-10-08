# ssl 握手

[https://razeencheng.com/post/ssl-handshake-detail.html](https://razeencheng.com/post/ssl-handshake-detail.html)

[https://www.jianshu.com/p/7158568e4867](https://www.jianshu.com/p/7158568e4867)

两篇文章结合看比较清晰。

主要过程![](/assets/ssl.png)  
1. Client hello，一个随机数 + 自己支持的加密算法有哪些  
2. Server hello，一个随机数 + 选定的算法+数字证书  
3. Server done,  服务端给个信号，老子该发的都发完了。  
4. Client Key Exchange（此时客户端拿到证书后，获得了可靠的公钥） 再搞一48字节随机数，然后用公钥加密 称为 预主密钥\(PreMaster Secret\)  
5. （内心活动）此时两端用三个随机数就可以搞成对称加密的密钥了。为啥3个随机数，我理解这个密钥必须不能重复在不同的会话中，而前面两个随机数是两端互相不信任对方能搞出唯一的uuid，第三个随机才算是密码。然后两端各自发送切换为加密传输的信号（见6）  
6. Change Cipher Spec\(Client\) ，老子从下条消息就开始加密传输了，注意到起  
7. Encrypted Handshake Message\(Client\) 先试一下，把之前的消息加密试试（client finish）  
 8. Change Cipher Spec\(Server\) 老子也从下一条开始整加密信息了  
9，Encrypted Handshake Message\(Server\)， 我也试一下，把之前的消息加密试试。

**整个过程其实主要在做两件事儿，1.传递公钥 2.商量传递对称加密的钥匙**  


**抓包看握手过程**![](/assets/ssl-tcpdump.png)  
从抓包看握手了，5次。但是理论上第二次和第三次是可以合并的，实际中往往第三次包很大，所以被分开。

**另外change cipher Spec、Change Cipher Spec、Finish也可能合并在一起。**

TLS

讲得比较清楚

[https://zhangbuhuai.com/post/tls.html](https://zhangbuhuai.com/post/tls.html)

常见面试问题

[http://blog.itpub.net/69952849/viewspace-2672996/](http://blog.itpub.net/69952849/viewspace-2672996/)

**总结**

1. TLS 是比较新的协议主流的版本是TLS1.3， TLS1.2 ,  SSL是以前的老协议，由网景公司提出，后来TLS标准化了SSL。

2. 数字签名，说白了你的正文可能非常大，所以加密解密都耗时。所以先对正文作hash，再对这个hash产物加密，最后的加密产物就是数字签名。验证的时候先用公钥解密（证明来源），解密后得hashA，然后自己再对正文进行hash得hashB，如果hashA===hashB，说明正文未被修改。

3. 数字证书https://www.ruanyifeng.com/blog/2011/08/what\_is\_a\_digital\_signature.html 软一峰这篇比较清楚。说白了是公钥不受信任，需要一个三方来验证公钥身份。如何验证呢？就是用第三方的私钥加密当前公钥+额外的信息（比如域名等）加密产物就是数字证书，验证这个数字证书的过程就是用第三方的公钥来解密数字证书。所谓数字证书原理其实就是用非对称加密来产生钥匙对，一环套一环。





