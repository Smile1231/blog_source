---
title: Spring Boot 获取服务IP地址和端口号
hide: false
tags:
  - Java
  - SpringBoot
categories: SpringBoot
keywords:
  - Java
  - SpringBoot
abbrlink: 67f40b37
date: 2022-05-21 22:58:51
---

> `IP`地址

`IP`地址非常简单, 直接上代码:
```java
try {
    String result = InetAddress.getLocalHost().getHostAddress();
} catch (UnknownHostException e) {
    LOGGER.error("获取IP失败", e);
}
```

<!-- more -->
> 端口号

获取端口号有四种方式:
```java
- `@Value`注解
- `@LocalServerPort`注解
- `Environment`

我们将`@Value和@LocalServerPort`放在一起, 其实`@LocalServerPort`等价于`@Value("${local.server.port}")`:
```java
@Value("${server.port}")
int serverPort;

@LocalServerPort
int localServerPort
```
这里要特别注意, 如果没有在配置文件中配置`local.server.port, @LocalServerPort`会为`null`
`Environment`本质和上述方法类似, 用它来读取配置属性:
```java
@Autowired
Environment environment;

public int getPort() {
    return environment.getProperty("server.port");
}
```
[参考链接](https://juejin.cn/post/6966920140461965320)
