---
title: 关于在IDEA中回滚Git版本
hide: false
tags:
  - Java
  - Git
categories: Git
keywords:
  - Java
  - Git
abbrlink: 424eebf1
date: 2022-02-12 20:13:57
---


今天在项目中使用`Git`想撤销已`Commit`但是没有`Push`的版本


一不小心点了`Drop`,导致代码全部丢失,瞬间人就没了,于是在紧急中我决定寻找救济方案

<!-- more -->

<br/>


首先执行`git reflog`查看本地记录,记录都是从最新的翻页显示到历史的,


{% asset_img 2022-02-12-20-17-28.png %}

退出浏览是在英文状态下按`Q`键

找到想回退的那一行操作,最前面是`HASH`值

然后在 `Terminal`中输入

`git reset --hard (hashValue)`

{% asset_img 2022-02-12-20-18-14.png %}

就可以了

吓死我了


同时如果在`IDEA`中想撤销上一次`Commit`,

{% asset_img 2022-02-12-20-18-47.png %}

在输入框中输入`HEAD~1`即可撤销上一次`Commit`

{% asset_img 2022-02-12-20-19-05.png %}



有惊无险!!!


