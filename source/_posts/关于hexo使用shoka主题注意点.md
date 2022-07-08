---
title: 关于hexo使用shoka主题注意点
hide: false
tags:
  - Hexo
abbrlink: 66edb7d2
date: 2022-07-08 09:57:07
categories:
keywords:
---

最近发现了一个特比好看的主题，叫 `shaoka` , [github 地址](https://github.com/amehime/hexo-theme-shoka) , 效果图不出意外的话应该就是我现在使用的这个`theme`了，同时博主也很贴心了贴了一些简单的[`wiki`文档](https://shoka.lostyu.me/computer-science/note/theme-shoka-doc/dependents/), [补充功能介绍点](https://www.reversesacle.com/Hexo-Shoka%E4%B8%BB%E9%A2%98%E5%8A%9F%E8%83%BD%E4%BB%8B%E7%BB%8D%E8%A1%A5%E5%85%85%E7%82%B9/)

可能我这个主题还是会有一点问题，目前有的大坑的话就是关于界面搜索功能的失效，参照上面的补充功能介绍点注册一个[`algolia`](https://www.algolia.com/).

需要注意的是，在`root`的`_config.yml`文件中需要输入一些配置信息,由于我之前`appId`一直写的是`applicaitonId`, 因为有些博客是这个，可能是老版本吧。

```yml
algolia:
   appId: "Application ID对应码"
   apiKey: "API Keys页面的All API Keys中刚刚新建的API key的对应码"
   adminApiKey: "Admin API Key对应码"
   chunkSize: 5000
   indexName: "你填写的Indices部分"
   fields:
     - title #必须配置
     - path #必须配置
     - categories #推荐配置
     - content:strip:truncate,0,4000
     - gallery
     - photos
     - tags
```

在`theme`的`_config.yml`文件中,加入或者修改以下配置,目前版本的`search`如果不配置，会报一个`hits`的错误
```yml
# Algolia Search
# For more information: https://www.algolia.com
search:
  enable: false
  hits:
    per_page: 10

algolia_search:
  enable: true
  hits:
    per_page: 10
  labels:
    input_placeholder: Search for Something 
    hits_empty: "We didn't find any results for the search: ${query}" # if there are no result
    hits_stats: "${hits} results found in ${time} ms"
```


