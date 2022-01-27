---
title: java中产生制定范围内的随机数
hide: false
abbrlink: 55cce9e3
date: 2022-01-27 22:40:14
tags:
categories:
keywords:
---

- `Math.random()`方法返回一个`[0.0 , 1.0)`的伪随机`double`类型的随机数

- `[min,max]`范围内的数
```java
int    num = min + (int)(Math.random() * (max-min));
double num = min + (Math.random() * (max-min));
```
<!-- more -->

- 用`nextInt`方法生成区间范围内的随机整数
```java
Random rand=new Random();
        int n1=rand.nextInt(100);//返回值在范围[0,100) 即[0,99]
        int n2=rand.nextInt(100)+1;//[1,100]内的随机整数
        int n3=rand.nextInt(80)+10;//[10,89]内的随机整数
        int n4=rand.nextInt(27)+82;//[82,108]内的随机整数
```
注意`rand.nextInt(n)`中的参数`n`代表的是生成随机整数的数量，与生成随机整数的范围无关。比如代码中的`n4`,整数取值为`[82,108]`,共`27`个数，加上后面的`82`表示区间最小值

生成`[min,max]`范围内随机整数的通用公式为：**`n=rand.nextInt(max-min+1)+min。`**


原文链接：https://blog.csdn.net/wsj_jerry521/article/details/109735801
