---
title: 使用hexo框架+next主题+githubPage搭建个人博客
hide: false
abbrlink: 3d071a12
date: 2021-11-10 22:19:19
tags:
categories: 
- Hexo
- Tools
keywords:
---

我自己的博客是采用了`hexo`+ `Next`主题搭建完成，并做了一些简单的配置，这边也将全面从0->1介绍

# 安装`Node`

`Node`的官网为 https://nodejs.org/zh-cn/download/  

{% asset_img 2021-11-13-00-33-44.png %} 

下载自己对应的版本即可，傻瓜式的下一步下一步之后，在终端控制台输入
```node
node -v
```

<!-- more -->

{% asset_img 2021-11-13-00-34-52.png %}

说明安装成功，而在这个时候也会给你安装了`npm`环境，输入
```node
npm -v
```
{% asset_img 2021-11-13-00-36-59.png %}

此时我们需要将原生的镜像源换为淘宝镜像源，这样能加快下载速度：
```node
# 设置镜像源
npm config set registry=https://registry.npm.taobao.org/
# 查看镜像源
npm config get registry
```

`Node`环境安装完毕

# 安装`Git`并创建`github pages`

git安装地址 ： https://git-scm.com/book/zh/v2/%E8%B5%B7%E6%AD%A5-%E5%AE%89%E8%A3%85-Git

`github`注册这边也不多赘述，不会的小伙伴可以自行百度

## 创建`github`项目

## 创建`responsibility`

{% asset_img 2021-11-13-21-03-18.png %}

{% asset_img 2021-11-13-21-04-34.png %}

这边我踩了个坑，命名格式好像必须是 `owner/owner.github.io`

然后`responsibility`就创建好了


## 生成``token``

按照图片步骤创建`token`

{% asset_img 2021-11-13-21-10-03.png %}

{% asset_img 2021-11-13-21-10-54.png %}

{% asset_img 2021-11-13-21-33-00.png %}

此时生成的`token`只会显示这一次，尽量复制保存到本地，据说这个`token`不开启`github Page`无法


## 设置`page`

{% asset_img 2021-11-15-22-00-27.png %}
点击`Settings`，向下拉到最后有个`GitHub Pages`，点击`Choose a theme`选择一个主题。然后等一会儿，此时点击图片中打码链接就是你的`GitHub Pages`地址了。应该是会跳出一个页面出来。

# 安装`Hexo`

选择一个合适的本地位置存在你的`Blog`源码，比如我就存放在`/Users/jinmao/Documents/Blog/blog_source/`处，然后输入全局安装`hexo`脚手架
```node
npm install -g hexo-cli
```
安装完后输入验证是否安装成功：
```node
hexo -v
```
{% asset_img 2021-11-15-23-18-45.png %}
说明安装成功啦！
```node
# hexo 常用指令

hexo init [folder]  //初始化本地文件夹为网站的根目录 - folder 为可选

//hexo new 命令用于新建文章，<title>字段需要加双引号
hexo n [layout] <title>

hexo generate //命令用于生成静态文件，一般可以简写为 hexo g
hexo d -g //指生成后再部署

hexo server //命令用于启动本地服务器，一般可以简写为hexo s
//-p 选项，指定服务器端口，默认为 4000
//-i 选项，指定服务器 IP 地址，默认为 0.0.0.0
//-s 选项，静态模式 ，仅提供 public 文件夹中的文件并禁用文件监视

hexo clean //命令用于清理缓存文件，是一个比较常用的命令

hexo deploy //命令用于部署网站，一般可以简写为 hexo d
```
说明 ：运行服务器前需要安装 `hexo-server `插件

```node
npm install hexo-server --save
```

使用`hexo -d`前需要修改` _config.yml `配置文件，下面以 `git` 为例进行说明
```yml
# Deployment
## Docs: https://hexo.io/docs/one-command-deployment
deploy:
  type: 'git'
  repo: <repository url>
  branch: master
  message: 自定义提交消息，默认为Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}
```
# 写文章、发布文章

创建一篇新文章,例如
```node
hexo n "写在最前面"
```
然后会在`source/_posts`下生成一个`markdown`文件，在这个文件中使用的是正常的`markdown`语法。
然后依次输入以下步骤：
```node
hexo clean //清理缓存

hexo g //编译生成静态文件

hexo s //启动本地服务器
```
{% asset_img 2021-11-17-00-01-23.png %}

`command + 左键`就可以在浏览器中浏览效果了

# 设置背景音乐

{% asset_img 2021-11-21-22-39-25.png %}
{% asset_img 2021-11-21-22-39-51.png %}
{% asset_img 2021-11-21-22-40-14.png %}

我们将音乐插件添加到侧边栏，效果类似于此`Blog`
打开我们主题文件：``themes\next\layout\_macro\sidebar.swig找到sidebar-inner``

{% asset_img 2021-11-21-22-38-07.png %}
就可以啦！

