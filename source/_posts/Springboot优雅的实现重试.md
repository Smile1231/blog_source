---
title: Springboot优雅的实现重试
hide: false
abbrlink: 49a9ac1a
date: 2022-07-05 22:49:37
tags:
- SpringBoot
categories:
keywords:
---

`guava-retrying` 包有一个重试工具，这便是重试示例代码，同时，参考文章有 [https://cloud.tencent.com/developer/article/1752086](https://cloud.tencent.com/developer/article/1752086)

引入`maven`包
```xml
<dependency>
    <groupId>com.github.rholder</groupId>
    <artifactId>guava-retrying</artifactId>
    <version>2.0.0</version>
</dependency>
```

<!-- more -->

封装为工具类
```java
public class RetryUtil {
private RetryUtil(){}

public static final Retryer<Boolean> retryer = RetryerBuilder.<Boolean>newBuilder()
        //重试条件
        .retryIfResult(aBoolean -> Objects.equals(aBoolean,false))
        //等待策略，此处为120秒重试一次
        .withWaitStrategy(WaitStrategies.fixedWait(150, TimeUnit.SECONDS))
        //停止策略，此处只重试10次
        .withStopStrategy(StopStrategies.stopAfterAttempt(10))
        .build();
}
````

测试

```java
@Slf4j
public class TestUtils {

    @Test
    void context() throws ExecutionException, RetryException {
        AtomicInteger j = new AtomicInteger();
        RetryUtil.retryer.call(() -> {
            log.info("start {} calculate",j.get());
           int i = j.get();
           if (i < 8){
               j.getAndIncrement();
               return false;
           }
           return true;
        });
    }
}
```
{% asset_img 2022-07-05-23-14-13.png %}






