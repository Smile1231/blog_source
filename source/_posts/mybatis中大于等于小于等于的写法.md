---
title: mybatis中大于等于小于等于的写法
hide: false
tags:
  - Java
  - Mybatis
categories: Mybtais
abbrlink: 9aff665a
date: 2021-12-16 19:39:45
keywords:
---

## `mybatis`中大于等于小于等于的写法

```xml
第一种写法（1）：

原符号       <        <=      >       >=       &        '        "
替换符号    &lt;    &lt;=   &gt;    &gt;=   &amp;   &apos;  &quot;
例如：sql如下：
create_date_time &gt;= #{startTime} and  create_date_time &lt;= #{endTime}

第二种写法（2）：
大于等于
<![CDATA[ >= ]]>
小于等于
<![CDATA[ <= ]]>
例如：sql如下：
create_date_time <![CDATA[ >= ]]> #{startTime} and  create_date_time <![CDATA[ <= ]]> #{endTime}
```

