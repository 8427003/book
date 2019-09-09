Docker 常用

docker 常用命令速查手册
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




