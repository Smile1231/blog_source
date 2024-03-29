---
title: 关于设置git以及npm代理
abbrlink: afe5178f
date: 2021-11-06 13:08:00
tags: git,npm,node
---

 我们在平时使用`git`或者`npm`等进行拉取项目或者安装一些需要科学上网的包时，就会报一些`connection timeout`的错误，这篇博客做了一些简单的汇总

## 关于`git`设置代理和取消代理

<!-- more -->


```bash
git config --global https.proxy http://127.0.0.1:1080
//https
git config --global https.proxy https://127.0.0.1:1080
//使用socks5代理的 例如ss，ssr 1080是windows下ss的默认代理端口,mac下不同，或者有自定义的，根据自己的改
git config --global http.proxy socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080

//只对github.com使用代理，其他仓库不走代理
git config --global http.https://github.com.proxy socks5://127.0.0.1:10808
git config --global https.https://github.com.proxy socks5://127.0.0.1:10808
//取消github代理
git config --global --unset http.https://github.com.proxy
git config --global --unset https.https://github.com.proxy

//查看代理
git config --global --get http.proxy
git config --global --get https.proxy

//取消全局代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

## 关于`npm`的设置代理和取消代理

```node
npm config set proxy socks5://127.0.0.1:10808
npm config set https-proxy socks5://127.0.0.1:10808

# npm设置镜像源
npm config set registry=http://registry.npmjs.org

# 查看镜像源
npm config get registry

# 淘宝镜像源 https://registry.npm.taobao.org/

# 取消代理
npm config delete proxy
npm config delete https-proxy
```

## 关于``git``修改推送仓库地址

> 查看远程仓库地址

```bash
git remote -v
```

方法有三种：

修改命令
```bash
git remote set-url origin [url]
```
先删后加
```bash
git remote rm origin
git remote add origin [url]
```

## `git`统计项目代码行数
>显示项目的所有文件列表及行数（已删除的文件显示为空）
最后一行会显示项目代码的总行数
```git
git ls-files | xargs wc -l
```
>只统计项目代码的总行数
```git
git ls-files | xargs cat | wc -l
```
>只查看项目文件列表
```
git ls-files
```

[查看`Ip` link click](https://ipaddress.com/website/github.com)

## git 更改user 信息

```git
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"

git config --list

git config --global credential.helper cache

```


<!-- https://github.com/microsoft/terminal -->
