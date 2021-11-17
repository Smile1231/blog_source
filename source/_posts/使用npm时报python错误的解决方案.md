---
title: 使用npm时报python错误的解决方案
hide: false
tags: node
categories: 前端
keywords: 'npm,node'
abbrlink: 3eca6246
date: 2021-11-17 09:32:54
---

由于本人是做后端的,最近有用到前端的一些东西,由于安装了`node`之后,`npm`是自带的,最近在,拉取前端的`web`项目之后,使用`npm install`之后,老是会报一个`node-sass`的错误,错误里面还夹杂了关于`python`的错误(也可能因为我之前安装了`anoconda`的原因,虽然卸载了,但还是报这样的错误)
{% asset_img 2021-11-17-10-21-32.png %}

## 解决方案

<!-- more -->

在网上找了很多解决方案,最后也是自己拼拼凑凑解决了,自己使用的`VSCODE`编译器,打开终端依次输入以下:
```node
npm install -g node-gyp

npm install --global --production windows-build-tools

npm install node-sass@latest //安装最新的node-sass
```

然后应该就不会报错啦!

