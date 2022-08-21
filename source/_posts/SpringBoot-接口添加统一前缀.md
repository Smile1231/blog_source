---
title: SpringBoot 接口添加统一前缀
hide: false
tags: SpringBoot
categories: SpringBoot
keywords:
  - SpringBoot
  - Springvc
abbrlink: 80a06b6b
date: 2022-08-21 21:46:23
---

为`SpringBoot`添加统一的接口路径前缀，例如`/api/1.0`这样。

写一个`Springboot`配置类即可:

```java
/**
 * @author jinMao
 * @version 1.0.0
 * @ClassName WebMvcConfig.java
 * @Description TODO
 * @createTime 2022-08-20  00:14:00
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {
        configurer.addPathPrefix("/api/1.0", c -> c.isAnnotationPresent(RestController.class));
    }
}
```
{% asset_img 2022-08-21-21-52-28.png %}

会自动带上前缀：

{% asset_img 2022-08-21-21-52-48.png %}

