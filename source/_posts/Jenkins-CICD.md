---
title: Jenkins/CICD
hide: false
tags:
  - Jenkins
  - CI/CD
categories: Jenkins
keywords:
  - Jenkins
  - CI/CD
abbrlink: 171f1b7f
date: 2022-08-08 22:40:05
---

[`Docker`中安装`Jenkins`](https://smile1231.github.io/posts/11faeb76/)

[`Java`操作`Jenkins`参考](https://www.cnblogs.com/yungyu16/p/12928802.html#%E6%93%8D%E4%BD%9C%E4%BB%BB%E5%8A%A1)

[参考文章](https://icode.best/i/82800046045409)


完成`jenkins`在docker中的启动安装对应的插件之后

由于我是使用的`docker`启动的`Jenkins`,所以需要在容器中装相应的环境：`jdk`,`maven`,`git`等等

进入容器内部:`docker exec -u root -it myJenkins10242 bash`


## 安装`vim`
> 在这之前需要对`apt`进行一下升级 
```bash
apt-get update
```

安装指令：
```bash
apt-get install vim
```
{% asset_img 2022-08-10-23-41-19.png %}

## 安装`jdk`
这里只讲解手动安装

查看架构，下载arm64版本的jdk，这里下载jdk11，[jdk 11 aarch64_bin.tar.gz](https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html#license-lightbox)
{% asset_img 2022-08-10-22-18-27.png %}

我这边将包放在了`docker`的挂载目录上
{% asset_img 2022-08-10-23-52-53.png %}

```bash
# 解压
tar -zxvf jdk-11.0.15_linux-aarch64_bin.tar.gz
# 配置环境变量
vim /etc/profile
```
在最后加上：
```bash
export JAVA_HOME=/var/jenkins_home/install_package/jdk-11.0.15/
export PATH=$PATH:$JAVA_HOME/bin
```

最后：`source /etc/profile` 即可

{% asset_img 2022-08-11-00-02-07.png %}
## 安装`maven`

安装`maven`的方法也类似，下载版本为[maven-3.5.4](https://archive.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz)

依然放在了挂在目录中的`install_package`中

解压：`tar -zxvf apache-maven-3.5.4-bin.tar.gz`

配置环境变量: `vim /etc/profile`
加上
```bash
export MAVEN_HOME=/var/jenkins_home/install_package/apache-maven-3.5.4
export PATH=$PATH:$MAVEN_HOME/bin
```
最后：`source /etc/profile` 即可

{% asset_img 2022-08-11-00-06-59.png %}

## `Git`
容器中自带了`git`，所以无需安装，但是需要查看路径: `which git`，路径为：`/usr/bin/git`

{% asset_img 2022-08-11-00-10-10.png %}

## 配置`Jenkins`

打开`Global Tool Configuration`:

{% asset_img 2022-08-11-00-12-49.png %}

这边是配置`maven`中的`settings`文件地址，我地址为：`/var/jenkins_home/install_package/apache-maven-3.5.4/conf/settings.xml`
{% asset_img 2022-08-11-00-15-24.png %}


分别配置上`jdk`,`git`,`maven`的本地目录,然后`Apply`和`Save`：
{% asset_img 2022-08-11-00-17-12.png %}

{% asset_img 2022-08-11-00-17-47.png %}

## 安装`plugin`

我们会发现新建一个`Item`是没有`Maven`项目的，需要安装一下对应的插件:`Maven Integration`
{% asset_img 2022-08-11-00-20-56.png %}

等待安装完成即可

## `Maven`项目部署测试

### 新建一个`Maven`，名字自取
{% asset_img 2022-08-11-00-22-22.png %}

### 项目描述：

{% asset_img 2022-08-11-00-26-00.png %}

### 配置`github`

{% asset_img 2022-08-11-00-29-23.png %}

> 关于`GitHub`凭证配置

配置地址： `https://github.com/settings/tokens`

{% asset_img 2022-08-11-00-30-37.png %}

{% asset_img 2022-08-11-00-31-02.png %}

将生成的`token`记载到本地
{% asset_img 2022-08-11-00-31-43.png %}

> `Jenkins`添加凭据

{% asset_img 2022-08-11-00-33-43.png %}

### `github`访问超时时间

检出超时时间：
{% asset_img 2022-08-11-00-34-52.png %}

`clone`超时时间：
{% asset_img 2022-08-11-00-36-01.png %}

### `Build`阶段

`clean package -Dmaven.test.skip=true -Prd -U`

{% asset_img 2022-08-11-00-39-04.png %}

### 配置构建项目后执行的`Shell`脚本

{% asset_img 2022-08-11-00-42-20.png %}

```bash
#!/bin/bash
#输入Maven打包后的项目名称
app=xxx-0.0.1-SNAPSHOT
#项目移动的目的地址
path=/usr/xxx
echo this is app : $app

#若项目已启动，杀死旧进程
api_pid=`ps -ef | grep "$app.jar" | grep -v grep | awk '{print $2}'`
echo api_pid = $api_pid

if [ "$api_pid" != "" ]; then
        echo kill api
        kill -9 $api_pid

        echo sleep 3s
        sleep 1
        echo sleep 2s
        sleep 1
        echo sleep 1s
        sleep 1
fi

#将jar包从jenkins工作空间中移动到指定路径下
mv /root/.jenkins/workspace/项目名/target/$app.jar $path
cd $path

#防止进程被杀死
BUILD_ID=dontKillMe

#后台进程形式启动项目，日志文件为out.log
nohup java -jar $app.jar >> out.log 2>&1 &
echo $app start success
exit 0
```
## `Jenkins`运行
{% asset_img 2022-08-11-00-43-49.png %}

{% asset_img 2022-08-11-00-45-15.png %}
