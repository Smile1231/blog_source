---
title: 如何让自己的博客被Google以及百度收录
hide: false
tags:
  - Hexo
  - Google
keywords:
  - Hexo
  - Google
abbrlink: 3c59e6c8
date: 2022-07-08 14:23:55
categories:
---

参考文章： [https://segmentfault.com/a/1190000037550362](https://segmentfault.com/a/1190000037550362)

这篇文章讲的很详细

## Agenda

突然奇想，我的博客能在`Google`或者百度上搜到吗，果不其然，是不能的，测试方法：

```
site:<域名>
```
例如我的：

```
site:smile1231.github.io
```

{% asset_img 2022-07-08-22-34-25.png %}


百度还在申请中：

{% asset_img 2022-07-08-22-36-33.png %}


## 百度申请

我们需要登录[百度搜索资源平台](https://link.segmentfault.com/?enc=M0oddaqZl%2BA77DeV5Zp5FA%3D%3D.584K%2BqKoJDUWqd%2BZHULHpah0eFzmv94a%2Fv2%2B5VX5dUk%3D)， 只要是百度旗下的账号就可以， 登录成功之后在站点管理中点击[添加网站](https://link.segmentfault.com/?enc=ynwAlf%2FyPvn%2BeI5pAR%2B8TQ%3D%3D.FK%2F1ZgEkA0w5%2F8CNcWgsOmW4v5y0w9m%2BKwkunbGLowqImo%2FtlP4qSzPZIjAqJbQ5)，输入域名，按照步骤走。

> 输入网址
{% asset_img 2022-07-08-22-39-27.png %}

> 一些站点标签
{% asset_img 2022-07-08-22-41-13.png %}

> 需要验证所有权，所以这边我选择了文件验证，需要将`html`文件进行下载
{% asset_img 2022-07-08-22-41-04.png %}

将`html`文件放在`theme`主题下的`source`文件夹中

{% asset_img 2022-07-08-22-43-41.png %}

> `Google` 文件下载
这边可以同时将[`Google`的`html`文件](https://search.google.com/search-console/welcome)也下载了

{% asset_img 2022-07-08-22-50-55.png %}

点击下载放在同样的位置：

{% asset_img 2022-07-08-22-53-06.png %}


> 依次执行`hexo clean` `hexo g` `hexo d`，需要等待部署完毕之后，访问 `https://<域名>/<htmlFileName>` ， 不报`404`就ok啦

{% asset_img 2022-07-08-22-56-26.png %}

{% asset_img 2022-07-08-22-57-11.png %}

> 点击验证完成即可
{% asset_img 2022-07-08-22-57-41.png %}

## 关于收录

{% asset_img 2022-07-08-23-01-54.png %}

### 使用`sitemap`方式推送

> `hexo`框架只需要在两个`sitemap`插件
```bash
npm install hexo-generator-sitemap --save 
npm install hexo-generator-baidu-sitemap --save
```

这两个插件是用来生成 `Sitemap`文件 的插件，而 `Sitemap`文件 是用来告诉搜索引擎我们的站点有哪些资源是可以抓取的。

安装完成后我们执行`hexo clean`&&`hexo g` 命令后我们会发现在`public` 目录下面会多了`baidusitemap.xml`和`sitemap.xml`文件。

> 安装`hexo-abbrlink`,这个会自动生成一个永久博客链接且不重复，同时需要配置`root`目录下的`_config.`

```yml
permalink: posts/:abbrlink/
abbrlink:
  alg: crc32   #算法： crc16(default) and crc32
  rep: hex     #进制： dec(default) and hex
```

> `hexo d`完成之后，可以访问 `https://<域名>/baidusitemap.xml`

{% asset_img 2022-07-08-23-33-54.png %}

回到百度提交`sitemap`界面，将`https://smile1231.github.io/baidusitemap.xml`填入然后提交即可，就会进入审核状态，需要耗时一段时间。

{% asset_img 2022-07-08-23-36-16.png %}

### `Google`提交`sitemap`

由于之前的插件也会在`public`目录下生成一个`sitemap.xml`，同样的在`google`站点地图中提交即可

{% asset_img 2022-07-08-23-38-49.png %}

`ex: sitemap.xml`

`google`收录会很快，估计几个小时即可！效果上图已经展示
