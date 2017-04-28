# 一、nginx

## 1. 先安check openssl版本

先用`openssl version`查看openssl 版本，如版本过低需要[https://www.openssl.org/](https://www.openssl.org/) 下载最新安装。此前在openss1.0.0作为依赖编译nginx后发现http2并没有工作。安装后执行 `openssl`如发现

```
openssl: error while loading shared libraries: libssl.so.1.1: cannot open shared object file: No such file or directory
```

这类错误，可以修复

```
centos:
ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
```

## 2. 源码编译安装nginx

依赖[https://nginx.org/en/docs/http/ngx\_http\_v2\_module.html](https://nginx.org/en/docs/http/ngx_http_v2_module.html) 模块

## 3. 配置

/etc/nginx/sites-available/www.css3.io.conf

```nginx
server {
        listen       80;
        server_name  www.css3.io css3.io;
        return         301 https://www.css3.io$request_uri;
}
server {
        listen       443 ssl http2;
        server_name  www.css3.io css3.io;
        ssl on;
        ssl_certificate /etc/ssl/private/letsencrypt-domain.pem;
        ssl_certificate_key /etc/ssl/private/letsencrypt-domain.key;
        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA;
        ssl_session_cache shared:SSL:50m;
        ssl_prefer_server_ciphers on;


        location / {
            root   /home/lijun/www;
            index  index.html index.htm;
        }
}
```

# 二、let's encrypt

进入官网[https://letsencrypt.org/](https://letsencrypt.org/，通过)  通过 [https://letsencrypt.org/getting-started/](https://letsencrypt.org/getting-started/) 找到 [many more ACME clients to choose from](https://letsencrypt.org/docs/client-options/)

nginx [acme-nginx](https://github.com/kshcherban/acme-nginx) 按照文档生成`sudo acme-nginx -d css3.io -d www.css3.io`

默认会生成（已在nginx配置中引用）

```
/etc/ssl/private/letsencrypt-domain.pem
/etc/ssl/private/letsencrypt-domain.key
```

# 三、自动续期

新建文件/etc/cron.d/renew-cert

```
MAILTO=8427003@qq.com
12 11 10 * * root /usr/local/bin/acme-nginx -d css3.io -d www.css3.io >> /var/log/letsencrypt.log
```

# 参考

[https://letsencrypt.org/](https://letsencrypt.org/)

[https://github.com/kshcherban/acme-nginx](https://github.com/kshcherban/acme-nginx)

