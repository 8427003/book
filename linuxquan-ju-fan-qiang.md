# linux全局翻墙

利用shadowsocks + iptables

iptables 最通俗易懂的学习网站

[http://www.zsythink.net/archives/1199](http://www.zsythink.net/archives/1199)



```
#!/bin/bash

################此代理貌似在测试 wget curl www.google.com不能正常访问，不知道为啥????
###############但是能测试通过其它墙外网站, 并且在阿里云测试通过安装k8s
##############参考实现https://blog.csdn.net/chouzhou9701/article/details/78816029
##############请用 wget www.youtube.com（不是youtube.com)命令测试，其它curl 命令或者目标网站不一定能走通#####

iptables -t nat -N SHADOWSOCKSR

###过滤掉本地访问
iptables -t nat -A SHADOWSOCKSR -d 0.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKSR -d 10.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKSR -d 100.64.0.0/10 -j RETURN
iptables -t nat -A SHADOWSOCKSR -d 127.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKSR -d 169.254.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKSR -d 172.16.0.0/12 -j RETURN
iptables -t nat -A SHADOWSOCKSR -d 192.168.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKSR -d 224.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKSR -d 240.0.0.0/4 -j RETURN

########### 代理服务器的ip(就是你shadowsock服务器ip)，避免循环这里需要手动改下ip #########################################
iptables -t nat -A SHADOWSOCKSR -d 69.171.65.233 -j RETURN

iptables -t nat -A SHADOWSOCKSR -p tcp -j REDIRECT --to-ports 1080

##挂载到PREROUTING链上
iptables -t nat -I PREROUTING -p tcp -j SHADOWSOCKSR

##挂载到OUTPUT链上
iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKSR



#####通过此链接说明安装ss-redir(shadowsocks-libev)
#####https://github.com/shadowsocks/shadowsocks-libev#install-from-repository-1
ss-redir -c /root/linux-global-GFW-master/shadowsocks.json &
read -p "按回车关闭代理"
killall ss-redir

######### 清除链 start #####################


#批量删除链在PREROUTING, OUTPUT 引用
#iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKSR 此方法只能清除单条存在bug，已废弃
iptables -t nat -S | grep " -p tcp -j SHADOWSOCKSR" | cut -d " " -f 2- | xargs -rL1 iptables -t nat -D

#清空链
iptables -t nat -F SHADOWSOCKSR
#删除链
iptables -t nat -X SHADOWSOCKSR
############# 清除链 end #############

echo "已经退出代理"
exit 0





#iptables -t nat -A PREROUTING -p tcp --dport 444 -j DNAT --to-destination 139.162.24.154:444
#iptables -t nat -A POSTROUTING -p tcp -d 139.162.24.154 --dport 444 -j SNAT --to-source 39.105.7.93 

#iptables -t nat -A PREROUTING -p udp --dport 444 -j DNAT --to-destination 139.162.24.154:444
#iptables -t nat -A POSTROUTING -p udp -d 139.162.24.154 --dport 444 -j SNAT --to-source 39.105.7.93 

#iptables -t nat  -L
#iptables -t nat  -F
```



