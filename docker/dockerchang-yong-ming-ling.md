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

docker images 
说明：查看 image 列表

docker rmi 
说名： 删除 image

docker run 
说明：针对image
例子：docker run -t -i  ubuntu bash

docker run (可选参数）
[-P] (随机端口映射） 
[-p xxx:8080] 本机到docker端口映射
[-d] background 运行

例子1：docker run --name myjenkins -p 8080:8080 -p 50000:50000 -v /var/jenkins_home jenkins 
例子2:  docker run -d -P aespinosa/jenkins
例子3:  docker run -t -i  ubuntu bash （打开bash）

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






