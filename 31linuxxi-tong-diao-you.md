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