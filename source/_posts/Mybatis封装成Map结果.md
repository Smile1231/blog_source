---
title: Mybatis封装成Map结果
hide: false
abbrlink: c112412d
date: 2022-02-13 21:42:17
tags:
- Java
- Mybatis
- SpringBoot
categories: 
- Java
- Mybatis
- SpringBoot
keywords:
- Java
- Mybatis
- SpringBoot
---

# `Mybatis`封装成`Map`结果

## `Dao`层

```java
@MapKey("cityCode")
Map<String,InvoiceSubjectRuleCity> bulkSelectRuleCityByRuleIdList(@Param("ruleIdList") List<Long> ruleIdList);
```
<!-- more -->

```xml
<select id="bulkSelectRuleCityByRuleIdList" resultMap="BaseResultMap">
    select
    <include refid="Base_Column_List"/>
    from t_invoice_subject_rule_city
    <where>
      rule_id in
        <foreach collection="ruleIdList" item="ruleId" open="(" close=")" separator=",">
           #{ruleId}
        </foreach>
    </where>
  </select>
``` 


返回结果即为`Map`类型




