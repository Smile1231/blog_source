---
title: Nginx踩坑之解决前后端跨域
hide: false
tags:
  - Java
  - Nginx
abbrlink: 7874a051
date: 2022-07-05 23:17:40
categories:
keywords:
---

## `nginx`配置前端跨域

注意点： 如果使用`nginx`解决跨域在前端使用`axios`是不需要写后端全路径的，类似于：

```js
//  原来我们需要写
axios.defaults.baseURL = 'http://localhost:9999/api'
// 现在改为
axios.defaults.baseURL = '/api'
```
这边不改动

<!-- more -->

{% asset_img 2022-07-05-23-34-01.png %}

因为如果使用了`Nginx`反向代理之后，部署服务器会有跨域的问题，如果仅仅只是后端处理，也不一定能行, 需要在配置文件中进行代理,`docker`中文件位置：
{% asset_img 2022-07-05-23-39-51.png %}

{% asset_img 2022-07-05-23-40-29.png %}

```properties
<!-- 解决跨域代理 -->
location /api/ {
proxy_pass http://58.198.178.163:9999/api/;
client_max_body_size 1024m;
}
<!-- 解决404 -->
error_page  404              index.html;
```

**Tips：此处一定要注意的是，`proxy_pass` 所对应的地址一定要是真实`ip`，要不然就回报`502`错误，真的是个大坑，也是我自己的问题！！！**： 


## `Nginx`与`Vue`打包成镜像

> `npm run build`打包,生成`dist`文件夹

> 在`dist`统计目录下，`vim Dockerfile`,在其中输入
```bash
FROM nginx

EXPOSE 80

COPY /dist /usr/share/nginx/html

ENTRYPOINT nginx -g "daemon off;"
```

> 打包命令:

```bash
docker build -t <image_name> .
```

> 查看镜像 ： `docker images`

> 运行： `docker run -d --name nginx_vue -p 8888:80 <image_name>`

> 进入容器：
```bash
docker exec -it nginx_vue /bin/bash
```

> `nginx`配置文件地址 `/etc/nginx/conf.d/default.conf`

## `Nginx`修改上传文件大小

```properties
client_max_body_size    1000m;
```



