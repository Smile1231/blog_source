---
title: Docker指令以及部署
hide: false
tags:
  - Docker
  - Java
abbrlink: 11faeb76
date: 2022-06-30 21:30:40
categories:
keywords:
---

文档地址：[https://yeasy.gitbook.io/docker_practice/](https://yeasy.gitbook.io/docker_practice/)

[Docker hub](https://hub.docker.com/)

[Docker Install](https://docs.docker.com/engine/install/)

## 列出所有镜像
```bash
docker images
```

## 查看运行的容器

```bash
docker ps
```
> 列出所有容器ID
```bash
docker ps -aq
```

<!-- more -->

## 查看所有的容器包括停止的
```bash
docker ps -a
```

## 删除
> 删除容器  
```bash
docker rm <NAMES>/<CONTAINER ID>
```
> 删除镜像
```bash
docker image rm <IMAGES>
```

{% asset_img 2022-06-30-22-57-53.png %}

## 停止、启动、杀死、重启一个容器

```bash
docker stop Name或者ID  
docker start Name或者ID  
docker kill Name或者ID  
docker restart name或者ID
```

## `docker`启动失败如何查看容器日志
```bash
# 我们可以通过如下命令来获取容器的日志地址
docker inspect --format '{{.LogPath}}' <NAMES>
#  然后通过cat命令查看上述命令找到的日志地址
```
{% asset_img 2022-06-30-23-11-07.png %}

> 更简单的方式
```bash
docker logs <NAMES>
```

## `M1`拉取`Mysql`数据库

```bash
docker pull --platform linux/x86_64 mysql:5.7

# 启动mysql
docker run --name mymysql -e MYSQL_ROOT_PASSWORD=root -d -p 3306:3306  mysql:5.7
```

## `Docker`安装`Nginx`并且部署`Vue`项目

### 拉取`Nginx`
```bash
docker pull nginx
```

### 创建挂载目录

找个目录创建一下目录（在`/Users/jinmao/Documents/Docker/`下创建`/nginx`）
```
mkdir
```

### 运行并且挂载`nginx`
```bash
docker run -d -p 80:80 --name nginx_BEBA  -v /Users/jinmao/Documents/Docker/nginx/dist:/usr/share/nginx/html --restart=always nginx
```

### 把`vue`的目录上传到挂载的目录

`vue`项目打包
```
npm run build
```

{% asset_img 2022-07-02-09-15-41.png %}

### 重启`Docker`容器
```
docker restart <NAMES>
```

此时就可以了，`nginx`开放端口为`80`,直接`ip`访问即可

### 为什么要挂载在到`docker`的`/usr/share/nginx/html`

看`nginx`的默认配置就知道
进入`docker`的容器里面：
通过命令`docker ps`查看运行容器信息；
在通过命令 `docker exec -it 容器id /bin/bash `进入容器目录

```bash
docker exec -it <NAMES> /bin/bash
```

进入`cd /etc/nginx/conf.d` , 查看`default.conf`文件
{% asset_img 2022-07-02-09-34-32.png %}


但是你会发现`etc/nginx`下有个`nginx.conf` 配置文件我们查看配置发现这里有条语句是引用了上面`default.conf`的配置，由此可见我们以后需要配置其他项目路径就直接配置`default.conf`就行了。

{% asset_img 2022-07-02-09-36-44.png %}

但是这个有个缺点每次修改都需要进入容器的内部求修改。

### 优化`nginx`的配置文件（为了以后多项目部署方便修改`Nginx`）

我们可以通过把`etc/nginx` 复制到宿主机的目录下这样我们就可以修改宿主机的配置文件在重新启动一下容器就可以实现最新的配置

1. 使用命令复制容器的文件到宿主机：`docker cp <NAMES>:/etc/nginx /Users/jinmao/Documents/Docker/nginx/`

    >`/etc/nginx`:为需要复制的文件

    >`/Users/jinmao/Documents/Docker/nginx/dist` :把他保存到那个目录下

    {% asset_img 2022-07-02-09-52-09.png %}

2. 进入`/nginx`修改宿主机(本地的)的`default.conf`配置文件命令

    {% asset_img 2022-07-02-10-35-29.png %}

3. 通过命令删除就的`nginx`容器：`docker rm 容器id` 删除容器

4. 重新启动容器
   ```bash
    docker run --name <name> -p 80:80 -v /Users/jinmao/Documents/Docker/nginx/dist:/Users/jinmao/Documents/Study/doctor/Topic1/frontPro/dist -v /Users/jinmao/Documents/Docker/nginx/nginx:/etc/nginx -d nginx

    # 解释：
    # –name：后面的是容器名称
    # -p:冒号前面是宿主机的对外端口，冒号后面的是容器的端口
    # -v：冒号前面的是宿主机的文件目录，冒号后面是容器的内部文件目录
    # -d:表示后端运行
    # nginx：最后面的nginx是镜像的名称
   ```
    {% asset_img 2022-07-02-11-08-24.png %}

现在已经把宿主机的`vue`项目`dist`挂载到`nginx`容器中，这样监听的请求就会被`nginx`代理到对应的目录中访问资源，还有宿主机的`/Users/jinmao/Documents/Docker/nginx/nginx`也被挂载到了容器`etc/nginx`中，这样只要修改宿主机的`nginx`配置,只要重启容器最新配置就会生效。


[参考链接](https://blog.51cto.com/u_15585699/5179688)


## 制作`Dockerfile`(`Springboot`)

`Maven` 打包完`jar`包，忽略。。

### 编辑`DockerFile`文件


和 `jar`包在同一级
```bash
vim Dockerfile
```
example:
```bash
# Docker image for springboot file run
# VERSION 1.0.0
# Author: jinmao
FROM java:8
VOLUME /tmp
EXPOSE 9999
ADD thesis-project.jar /app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-jar","/app.jar"]
```
> 打包命令
```bash
docker buil -t <lower_name> .
```
{% asset_img 2022-07-02-13-32-00.png %}

> 运行
```bash
docker run -p 9999:9999 --name BABE_Thesis -d babe_end
```
{% asset_img 2022-07-02-13-35-28.png %}


## `Docker`安装`Jenkins`

原理图：
{% asset_img 2022-08-04-23-24-21.png %}

1. 拉取镜像(稳定版本)
```bash
docker pull jenkins/jenkins:lts
```
{% asset_img 2022-08-04-23-21-06.png %}

2. 创建挂载目录

> 创建目录
```bash
/Users/jinmao/Documents/Docker/jenkins_mount
```

3. 运行容器

```bash
# -d 后台运行镜像
# -p 10240:8080 将镜像的8080端口映射到服务器的10240端口。
# -p 10241:50000 将镜像的50000端口映射到服务器的10241端口
# -v /Users/jinmao/Documents/Docker/jenkins_mount:/var/jenkins_home /var/jenkins_home目录为容器jenkins工作目录，我们将硬盘上的一个目录挂载到这个位置，方便后续更新镜像后继续使用原来的工作目录。这里我们设置的就是上面我们创建的 /Users/jinmao/Documents/Docker/jenkins_mount 目录
# -v /etc/localtime:/etc/localtime让容器使用和服务器同样的时间设置。
# --name myJenkins 给容器起一个别名
docker run -d -p 10240:8080 -p 10241:50000 -v /Users/jinmao/Documents/Docker/jenkins_mount:/var/jenkins_home -v /etc/localtime:/etc/localtime --name myJenkins jenkins/jenkins:lts
```
{% asset_img 2022-08-05-00-10-33.png %}

4. 查看`jenkins`是否启动成功
```bash
docker ps
```
{% asset_img 2022-08-05-00-12-41.png %}

5. 查看`docker`容器日志。

```bash
docker logs <name> 
# docker logs myJenkins
```
{% asset_img 2022-08-05-00-14-43.png %}

6. 进入挂载目录

{% asset_img 2022-08-05-00-15-42.png %}

可选做:
`vim`修改 `hudson.model.UpdateCenter.xml`里的内容,将 `url` 修改为 清华大学官方镜像：`https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json`

7. 访问`Jenkins`
```bash
localhost:10240
```
{% asset_img 2022-08-05-00-20-45.png %}

根据提示输入密码
{% asset_img 2022-08-05-00-26-18.png %}

8. 安装 `plugin`

{% asset_img 2022-08-05-00-27-44.png %}

安装完成即可使用
{% asset_img 2022-08-05-00-28-01.png %}


