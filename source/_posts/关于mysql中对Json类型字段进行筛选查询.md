---
title: 关于mysql中对Json类型字段进行筛选查询
hide: false
date: 2022-01-11 11:15:26
tags:
- 数据库
- Mysql
categories: 数据库
keywords:
- 数据库
- Mysql
---

最近用到了对`Mysql`中对`JSON`类型的字符串进行筛选,这边做个简单的总结:

添加筛查条件
```sql
select * from table_name where JSON_EXTRACT(JSON_String,'$.json字段名') = '' and ...
```

`JSON`筛查加更新
```sql
update table_name set JSON_String = json_replace(JSON_String, '$.json字段名', 'jinmao')
where id in (?,?)
```
<!-- more -->
