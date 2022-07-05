---
title: JAVA-jar包运行及日志输出
hide: false
tags:
  - SpringBoot
abbrlink: f35c5140
date: 2022-07-05 22:01:26
categories:
keywords:
---

[原文地址](https://www.cnblogs.com/lsh-admin/p/15345176.html)


一般情况下运行jar包，当前是可运行的jar包，直接命令
```java
java -jar common.jar 
```
按下`ctrl+C` ，关闭当前`ssh`或者直接关闭窗口，当前程序都会退出。

<!-- more -->


我们在命令的结尾添加 `“&”` ，&表示该程序可以在后台执行
```java
java -jar common.jar &
```
 但是在当窗口关闭时，程序也会中止运行

```java
nohup java -jar common.jar &
```
命令最前面个`nohub`关键字，这样程序就会不挂断运行命令, 当ssh终端关闭时,程序仍然在运行，当前程序的日志会被写入到当前目录的`nohup.out`文件中

我们可以改下输入的日志文件
```java
nohup java -jar common.jar > log.out &
```
当前程序的日志会被写入到当前目录的`log.out`文件中

如果不想写日志，可以将日志重定向到 `/dev/null` 中，`/dev/null`代表`linux`的空设备文件，所有往这个文件里面写入的内容都会丢失
```java
nohup java -jar common.jar > /dev/null &
```
标准输出就会不再存在，没有任何地方能够找到输出的内容

 
```java
nohup java -jar common-api.jar >/dev/null 2>log.error & 
```
只输出错误信息到日志文件，标准输出不写入日志文件，直接丢弃

 
```java
nohup java -jar common-api.jar >/dev/null 2>&1 & 
```
标准输出`(stdout)`重定向到`/dev/null`中（丢弃标准输出），然后标准错误输出`(stderror)`由于重用了标准输出的描述符，所以标准错误输出也被定向到了`/dev/null`中，错误输出同样也被丢弃了

 
```java
nohup java -jar common-api.jar >log.out 2>&1 & 
```
标准输出重定向到`log.out`中，然后错误输出由于重用了标准输出的描述符，所以错误输出也被定向到了`log.out`中 

 

但是不管那种情况，如果日志输出，日志文件都会增加很快，造成单个文件很大。所以需要拆分文件

1. 定时作业，每天将日志文件复制一份，然后将当前的日志文件清空。

2. 借助 `cronolog`来分隔日志
```java
nohup java -jar common-api.jar | /usr/local/cronolog/sbin/cronolog logs/console-%Y-%m-%d.out &
```
这样每天会产生一个`console`开头的日志文件。



