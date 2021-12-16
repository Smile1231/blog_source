---
title: 获取指定集合要求中的mapkey值并重新返回map
hide: false
tags:
  - map
  - Stream流
categories: Java
keywords:
  - map
  - Stream流
abbrlink: 97604c34
date: 2021-12-16 16:21:02
---

最近遇到一个很奇怪的诉求,进行分批处理时,所得到的是一个`List<List<String>> partition = Lists.partition(list, 1000)`的分批`List`,由于只是一个类似于`Map<string,Object>`的`key`值进行了分组,但是业务方法使用了后面的实体类,所以想将`value`值保持和前面分组一致,同时`map`的`key`值变成`Object`实体类的其他属性.
<!-- more -->

```java
//先根据某个值进行分类
List<List<String>> partition = Lists.partition(list, 1000);
partition.forEach(m ->  {
                    Map<String, DriverSettlement> driverSettlementMap = m.stream()
                            .map(driversMap::get).collect(Collectors.toMap(Student::getId, t -> t));
                    method(driverSettlementMap);
                });
//这边的t->t 表示本身
```

