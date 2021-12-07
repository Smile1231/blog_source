---
title: mysql日期加减
hide: false
categories: 数据库
keywords:
  - 数据库
  - DataBase
abbrlink: 388f5c14
date: 2021-12-07 19:20:01
tags:
---

# 日期的加减
`date_add`和`date_sub`
语法为：`date_add(date,interval expr type)、date_sub(date,interval expr type)`
其中常用的type的类型有：`second、minute、hour、day、month、year`等

`date_add`是对日期的增加，如果天数为负数时，则表示对日期减少，
`date_sub`是对日期的减少，如果天数为负数时，则表示对日期增加
例如
<!-- more -->
```sql
-- 获取日期 2020-04-07
curdate()
-- 获取日期加时间 2020-04-07 23:10:30
now()
-- 获取明天的日期 2020-04-08
date_add(curdate(),interval 1 day)
--或者
date_sub(curdate(),interval -1 day)
-- 获取明年的日期 2021-04-07
date_add(curdate(),interval 1 year)
-- 或者
date_sub(curdate(),interval -1 year)
```

# 日期的格式化
## `date_format`

语法为：`date_format(date,format)，date` 参数是合法的日期。`format `规定日期/时间的输出格式。
常用的格式有：

格式 |	描述
---- | ---
%Y |	年，4 位
%y |	年，2 位
%m |	月，数值(00-12)
%M |	月名
%D |	带有英文前缀的月中的天
%d |	月的天，数值(00-31)
%H |	小时 (00-23)
%h |	小时 (01-12)
%i |	分钟，数值(00-59)
%S |	秒(00-59)
%s |	秒(00-59)
```sql
-- 格式化当前日期 2020-04-07 23:23:23
date_format(now(),'%Y-%m-%d %H:%i:%s' )
```
# 日期的差值
## `datediff`
`DATEDIFF(date1，date2)` 返回起始时间 `date1` 和结束时间 `date2` 之间的天数（`date2-date1`，正负情况都存在）。`date1` 和` date2` 为日期或 `date-and-time `表达式，计算差值时只会计算日期的差值，单位为天。
```sql
-- 当前时间2020-04-08，差值为-2
SELECT DATEDIFF(NOW(),'2020-04-10') 
-- 当前时间2020-04-08，差值为2
SELECT DATEDIFF(NOW(),'2020-04-06') 
```

## `timestampdiff`
语法为：`TIMESTAMPDIFF(interval,datetime_expr1,datetime_expr2)。`
返回日期或日期时间表达式`datetime_expr1 和datetime_expr2the `之间的整数差。其结果的单位由`interval` 参数给出。
常用的值有：
```sql
FRAC_SECOND。表示间隔是毫秒
SECOND。秒
MINUTE。分钟
HOUR。小时
DAY。天
WEEK。星期
MONTH。月
QUARTER。季度
YEAR。年


-- now()值为 2020-04-08 23:20:20
SELECT TIMESTAMPDIFF(DAY,NOW(),'2020-04-10 23:23:23') 
-- 结果为2，相差两天，取整数
-- 其他单位同理
```
