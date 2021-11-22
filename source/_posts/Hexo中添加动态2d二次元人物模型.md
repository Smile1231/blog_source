---
title: Hexo中添加动态2d二次元人物模型
hide: false
categories: Hexo
abbrlink: 5c2529f6
date: 2021-11-21 23:18:56
tags:
keywords:
---

``Hexo``添加`helper-live2d`型插件

[`github`地址](https://github.com/EYHN/hexo-helper-live2d/blob/master/README.zh-CN.md)


# 安装插件
```bash
npm install --save hexo-helper-live2d
```
<!-- more -->

# 下载模型

作者提供以下模型的模型包，模型包预览地址见下面的链接，选择你想用的模型，记住名字，选择对应的后缀模型包

[模型包展示](https://github.com/xiazeyu/live2d-widget-models)

```
live2d-widget-model-chitose
live2d-widget-model-epsilon2_1
live2d-widget-model-gf
live2d-widget-model-haru/01 (use npm install --save live2d-widget-model-haru)
live2d-widget-model-haru/02 (use npm install --save live2d-widget-model-haru)
live2d-widget-model-haruto
live2d-widget-model-hibiki
live2d-widget-model-hijiki
live2d-widget-model-izumi
live2d-widget-model-koharu
live2d-widget-model-miku
live2d-widget-model-ni-j
live2d-widget-model-nico
live2d-widget-model-nietzsche
live2d-widget-model-nipsilon
live2d-widget-model-nito
live2d-widget-model-shizuku
live2d-widget-model-tororo
live2d-widget-model-tsumiki
live2d-widget-model-unitychan
live2d-widget-model-wanko
live2d-widget-model-z16
```

选择好对应的模型，使用 `npm install` 模型的包名来安装

# 打开个人`Hexo`博客文件根目录下的 `_config.yml` 文件，在最后添加一下代码
```yml
live2d:
  enable: true
  scriptFrom: local
  pluginRootPath: live2dw/
  pluginJsPath: lib/
  pluginModelPath: assets/
  tagMode: false
  debug: false
  model:
    use: live2d-widget-model-koharu
  display:
    position: right
    width: 150
    height: 300
  mobile:
    show: true
```
# 重启项目
```bash
hexo clean && hexo g && hexo s
```