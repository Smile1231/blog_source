---
title: Windows下如何查看某个端口被谁占用
hide: false
abbrlink: e694a882
date: 2021-12-16 18:59:13
tags:
categories:
keywords:
---

## 查找所有运行的端口
```shell
netstat -ano
```

<!-- more -->
## 查看被占用端口对应的 `PID`
输入命令：
```shell
netstat -aon|findstr "8081"
```
## 查看指定 `PID` 的进程
继续输入命令：
```shell
tasklist|findstr "9088"
```

## 结束进程
强制（`/F`参数）杀死 `pid` 为 9088 的所有进程包括子进程（`/T`参数）：
```shell
taskkill /T /F /PID 9088 
```

