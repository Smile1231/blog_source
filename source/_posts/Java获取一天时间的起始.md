---
title: Java获取一天时间的起始
hide: false
tags:
  - java
  - calender
categories: 
- Java
- Tools
abbrlink: 49b96938
date: 2021-12-16 17:36:55
keywords:
---

如何获取一个指定日期的一天起始时间呢:`hutool`中有自带的方法:

<!-- more -->

```gradle
implementation group: 'cn.hutool', name: 'hutool-all', version: '5.7.16'
```
## 获取当天的开始时间
```java
DateUtil.beginOfDay(new Date())
```
## 获取当天的结束时间
```java
DateUtil.endOfDay(new Date())
```

## 在这里获取昨天的开始和结束时间需要结合`Calendar`和`hutool`一起使用
```java
SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

//例如今天是 2021-12-16 16:55:45
//获取昨天开始的时间
Date beginOfDay = DateUtil.beginOfDay(new Date());
Calendar c = Calendar.getInstance();
c.setTime(beginOfDay);
c.add(Calendar.DAY_OF_MONTH,-1);
Date yesterBeginDay = c.getTime();
String a = simpleDateFormat.format(yesterBeginDay);
System.out.println(a);

输出结果：2021-12-15 00:00:00
    
//获取昨天结束的时间
Date endOfDay = DateUtil.endOfDay(new Date());
c.setTime(endOfDay);
c.add(Calendar.DAY_OF_MONTH,-1);
Date yesterEndDay = c.getTime();
String b = simpleDateFormat.format(yesterEndDay);
System.out.println(b);

输出结果：2021-12-15 23:59:59
```
