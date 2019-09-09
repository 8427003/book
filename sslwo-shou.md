ssl 握手

https://razeencheng.com/post/ssl-handshake-detail.html

https://www.jianshu.com/p/7158568e4867 

两篇文章结合看比较清晰。



主要过程
1. Client hello，一个随机数 + 自己支持的加密算法有哪些
2. Server hello，一个随机数 + 选定的算法+数字证书
3. Server done,  服务端给个信号，老子该发的都发完了。
4. Client Key Exchange（此时客户端拿到证书后，获得了可靠的公钥） 再搞一48字节随机数，然后用公钥加密 称为 预主密钥(PreMaster Secret)
5. （内心活动）此时两端用三个随机数就可以搞成对称加密的密钥了。为啥3个随机数，我理解这个密钥必须不能重复在不同的会话中，而前面两个随机数是两端互相不信任对方能搞出唯一的uuid，第三个随机才算是密码。然后两端各自发送切换为加密传输的信号（见6）
6. Change Cipher Spec(Client) ，老子从下条消息就开始加密传输了，注意到起
7. Encrypted Handshake Message(Client) 先试一下，把之前的消息加密试试（client finish）
 8. Change Cipher Spec(Server) 老子也从下一条开始整加密信息了
9，Encrypted Handshake Message(Server)， 我也试一下，把之前的消息加密试试。

整个过程其实主要在做两件事儿，1.传递公钥 2.商量传递对称加密的钥匙

