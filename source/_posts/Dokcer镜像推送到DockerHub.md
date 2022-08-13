---
title: Dokcer镜像推送到DockerHub
hide: false
abbrlink: e2b12017
date: 2022-08-11 00:52:36
tags: Docker
categories: Docker
keywords: Docker
---

关于推送本地的镜像到`Docker Hub`上

关于如何制作镜像：[make DockerFile](https://smile1231.github.io/posts/11faeb76/)


## 注册账号

[official Website](https://hub.docker.com/)

注册完成之后，进入自己的账户信息页创建`Token`

{% asset_img 2022-08-13-10-51-18.png %}

## 本地登陆账号
```bash
docker login

# Username: jinmaohub
# Password: ${token}
# Login Successed
```

## 推送镜像
> get images 
```bash
docker images
```
{% asset_img 2022-08-13-10-48-38.png %}

> 用`docker tag`来进行标记

```bash
docker tag <image-name> <docekerhub-name>/<iamges-name>:<tag-name>
# docker tag local_vue jinmaohub/local_vue:latest
```

> 推送`images`

```bash
docker push <docekerhub-name>/<iamges-name>:<tag-name>
# docker push jinmaohub/local_hub:latest
```
{% asset_img 2022-08-13-11-20-34.png %}

就会发现镜像推送成功了

{% asset_img 2022-08-13-11-20-56.png %}



