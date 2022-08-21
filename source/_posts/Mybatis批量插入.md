---
title: Mybatis批量插入
hide: false
tags: Mybatis
categories: Mybatis
keywords:
  - Mybatis
  - 批量插入
abbrlink: cb74ceb6
date: 2022-08-21 21:57:09
---

关于`Mybatia`实现插入`List`,每次一段时间就忘了，这次决定记载下来。


> `Mapper层接口`
```java
void bulkInsertAppTable(List<AppTable> appTableList);
```
> `Xml实现`
```xml
<insert id="bulkInsertAppTable" parameterType="list" useGeneratedKeys="true" keyProperty="id">
insert into app_table
    (application_name,create_by)
values
    <foreach collection="appTableList" index="index" item="appTable" open="" close="" separator=",">
        (
            #{appTable.applicationName,jdbcType=VARCHAR},
            #{appTable.createBy,jdbcType=VARCHAR}
        )
    </foreach>
</insert>
```


