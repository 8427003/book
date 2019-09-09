Docker 常用

docker 常用命令速查手册
—————————————————————————————————————————————————————
docker run --name mycentos   -it  centos:latest bash
说明：通用启动镜像为容器并且命令行：
   - -  name  为容器取一个别名，- -rm容器退出后自动删除容器（可以不用这个）

docker run --name mycentos  -d centos:latest /run.sh
说明：通用启动镜像启动指定脚本时，no exited 
https://stackoverflow.com/questions/30209776/docker-container-will-automatically-stop-after-docker-run-d
-d 为主机background 运行，
如果run.sh 也是background运行，则会exited。所以必须run.sh foreground运行(可用run.sh脚本最后加tail -f /dev/null 实现）

docker exec -it b07599e429fb bash
说明：通用链接容器命令行：


docker 实现宿主机随机端口
说明：容器的端口必须确定，要么Dockerfile  EXPOSE 指令暴露， 要么docker 使用者知道容器端口）
1. -p :3000（docker 使用者知道容器端口）
2. -P （大写P，依赖Dockerfile  EXPOSE 指令暴露）

Docker file 是为了build image， no for container

docker-compose.yml   命令：docker-compose up.  docker-compose -f xxx.yml up -d
https://docs.docker.com/compose/gettingstarted/
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - -



docker ps -a 
说明：查看contaner 状态及其列表

docker exec
说明： 真对container
例子：docker exec -it facenode_facenode_1 bash

docker start
说明：启动container

docker attach 
说明：链接container，必须等docker start
例子：docker attach topdemo

docker rm 
说明：删除container
例子：docker rm -v redis

docker rename CONTAINER NEW_NAME
说明：重新命名

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - -

docker logs:
说明：观察查容器日志，遇到过一个场景，docker 一直处于restarting 状态，起不来，打开日志后发现共享目录权限拒绝。chmod后容器就起来了。
例子：docker logs --follow   <CONTAINER ID>

———————————————————————————————————————————————————————————
docker save: 
说明：persist an image (not a container)
例子：docker save busybox-1 > /home/save.tar

docker load:
说明：还原一个image 从 docker save 生成的压缩包
docker load < /home/save.tar 

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - -

docker export:
说明: persist a container (not an image)
例子：docker export <CONTAINER ID> > /home/export.tar

docker import:
说明：还原一个container 和 image 从一个 docker export 打包的文件
例子：cat /home/export.tar   sudo docker import - busybox-1-export:latest

docker save vs docker export
从历史可以看到：sudo docker images --tree
docker load 还原的image更大，包含较多提交历史,
docker import 只是一个镜像，相对少

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - -

docker build:
说明：Build an image from a Dockerfile
例子： docker build - < Dockerfile

———————————————————————————————————————————————————————————

docker commit <container-id> <image-name>
说明：保存当前container 为image
例子：sudo docker commit <CONTAINER ID> busybox-1

———————————————————————————————————————————————————————————

公司私有源

http://100.73.46.2/repositories/100
———————————————————————————————————————————————————————————

命令手册

https://docs.docker.com/engine/reference/commandline/build/#build-with--

mongo
https://www.thachmai.info/2015/04/30/running-mongodb-container/



修改docker 镜像
https://www.docker-cn.com/registry-mirror
[“https://ovrybrlc.mirror.aliyuncs.com", "https://registry.docker-cn.com”]
