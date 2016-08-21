#背景

[gitbook](https://www.gitbook.com/)既是一个网站，专业提供写书的地方服务。也是一个基于node平台的应用，可以生产静blog。然而它作为网站，提供了在线访问的服务，这是我用gitbook生成的静态blog：http://www.css3.io

做一个这样的blog很容易，类似于github创建一个源，blog就自己生成了，自定义域名也支持。如果觉得gitbook不靠谱，还可以将源码托管到github,然后通过github的webhooks关联到gitbook，去gitbook设置项看一下就懂怎么操作了，都不用文档。最后直接提交代码到github就会触发webhooks，gitbook就会生成静态blog了，相当简单。

但是有个问题，**gitbook托管的静态blog访问速度没有github的[GitHub Pages](https://pages.github.com/)快**，有时候10s左右都没响应，确实蛋疼。于是乎不用gitbook提供的在线访问服务了，直接用它生成静态blog，然后用github pages来支持在线访问，**但又想跟使用gitbook一样方便。这个时候[travis](https://travis-ci.org/)派上用场了**。

---

# 步骤

### 1.注册一个travis号，加入需要持续集成的github源。

### 2.去github生成tokens

以便travis脚本通过调用github api时不用密码上传代码到github仓库。github设置地址
https://github.com/settings/tokens

### 3.将生成的token增加到travis环境变量中
在travis对应的源setting里增加一个Environment Variables，key为"GH_TOKEN",值为token字符串

### 4.将以下文件增加到github源里

1.文件：[deploy.sh](https://raw.githubusercontent.com/8427003/book/master/deploy.sh)

我这里是将源码托管到我的
https://github.com/8427003/book

将生成的静态文件托管到我的组织项目
https://github.com/lijun401338/lijun401338.github.io
（因为我发现组织GitHub Pages比Project Pages方式静态blog访问速度更快)，当然这里也可以以Project Pages方式托管到当前项目分支gh-pages（如果没有必须先手动创建）。deploy脚本需要根据自己的情况配置。


更多
[User, Organization, and Project Pages区别](https://help.github.com/articles/user-organization-and-project-pages/)


```shell
#!/bin/bash

set -o errexit -o nounset

if [ "$TRAVIS_BRANCH" != "master" ]
then 
    echo "This commit was made against the $TRAVIS_BRANCH and not the master! No deploy!" 
    exit 0
fi

rev=$(git rev-parse --short HEAD)

cd _book

git initgit config user.name "8427003"git config user.email "8427003@qq.com"

git remote add upstream "https://$GH_TOKEN@github.com/lijun401338/lijun401338.github.io.git"git fetch upstreamgit reset upstream/master

echo "www.css3.io" > CNAME

git add -A

git commit -m "rebuild pages at ${rev}"

git push -q upstream HEAD:master

```


2.文件：[.travis.yml](https://raw.githubusercontent.com/8427003/book/master/.travis.yml)

```yml
language: "node_js"
node_js:
 - "node"
install:
 - "npm install gitbook -g"
 - "npm install -g gitbook-cli"
script:
 - "gitbook build"
after_success:
 - "sh deploy.sh"

```

### 参考：
https://github.com/steveklabnik/automatically_update_github_pages_with_travis_example
