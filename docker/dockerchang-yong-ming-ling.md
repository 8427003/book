Docker 常用

docker 常用命令速查手册
docker run --name mycentos   -it  centos:latest bash
说明：通用启动镜像为容器并且命令行：
    name  为容器取一个别名，- -rm容器退出后自动删除容器（可以不用这个）

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

docker images 
说明：查看 image 列表

docker rmi 
说名： 删除 image

docker run 
说明：针对image
例子：docker run -t -i  ubuntu bash

docker run (可选参数）


docker export:
说明: persist a container (not an image)
例子：docker export <CONTAINER ID> > /home/export.tar

docker import:
说明：还原一个container 和 image 从一个 docker export 打包的文件
例子：cat /home/export.tar | sudo docker import - busybox-1-export:latest






