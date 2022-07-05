---
title: VsCode 如何Debug Shell
hide: false
tags:
  - VsCode
  - Shell
abbrlink: 823298d2
date: 2022-07-01 10:58:13
categories:
keywords:
---


## 1. 下载`Vscode`插件 `Bash Debug`

{% asset_img 2022-07-01-10-59-08.png %}

<!-- more -->

## 2. `create launch.json file`

选择`Bash Debug`
{% asset_img 2022-07-01-11-04-35.png %}

## 3. 添加配置
{% asset_img 2022-07-01-11-06-45.png %}

{% asset_img 2022-07-01-11-07-31.png %}

使用下拉菜单选中刚刚我们添加的 `select script from list of sh files`，点击播放键运行。

选择想`debug`的脚本，然后开始

## 4. 查看变量名

```bash
${变量名}
# 格式来添加，要确认哪个就添加哪个。
```

