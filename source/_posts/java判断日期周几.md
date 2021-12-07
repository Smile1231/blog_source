---
title: java判断日期周几
hide: false
date: 2021-12-07 19:17:30
tags: 
- Java
- 日期
categories: Java
keywords:
- Java
- Calendar
---

```java
DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
String Date = "2020-08-03";  //定义初始是周一
Date testdate = sdf.parse(Date);
Calendar cal = Calendar.getInstance();
cal.setTime(testdate); 
if(cal.get(Calendar.DAY_OF_WEEK)==Calendar.MONDAY){
    System.out.println(sdf.format(cal.getTime())+"========="+"是周一=========");
}
//日期加一天
cal.add(Calendar.DATE,1);
if(cal.get(Calendar.DAY_OF_WEEK)==Calendar.TUESDAY) {
    System.out.println(sdf.format(cal.getTime())+"========="+"是周二=========");
}
cal.add(Calendar.DATE,1);
if(cal.get(Calendar.DAY_OF_WEEK)==Calendar.WEDNESDAY){
    System.out.println(sdf.format(cal.getTime())+"========="+"是周三=========");
}
cal.add(Calendar.DATE,1);
if(cal.get(Calendar.DAY_OF_WEEK)==Calendar.THURSDAY){
    System.out.println(sdf.format(cal.getTime())+"========="+"是周四=========");
}
cal.add(Calendar.DATE,1);
if(cal.get(Calendar.DAY_OF_WEEK)==Calendar.FRIDAY){
    System.out.println(sdf.format(cal.getTime())+"========="+"是周五=========");
}
cal.add(Calendar.DATE,1);
if(cal.get(Calendar.DAY_OF_WEEK)==Calendar.SATURDAY){
    System.out.println(sdf.format(cal.getTime())+"========="+"是周六=========");
}
cal.add(Calendar.DATE,1);
if(cal.get(Calendar.DAY_OF_WEEK)==Calendar.SUNDAY){
    System.out.println(sdf.format(cal.getTime())+"========="+"是周日=========");
}
```

