---
title: 关于junit测试类防止事务回滚
hide: false
tags:
  - junit
  - Java
  - Spring
categories:
  - Java
keywords:
  - junit
  - Java
  - Spring
abbrlink: b536fa7f
date: 2022-02-12 12:24:55
---

> 背景
昨晚在做一个`Junit`测试时，使用了事务来测试某个业务，但是意外发现，在``SpringBoot`测试中会自定帮你回滚掉`CUD`操作，下面是自己做的简单测试:

<!-- more -->

{% asset_img 2022-02-12-16-03-00.png %}

```java
@SpringBootTest
public class StudentMapperTest {
    @Test
    @Transactional(rollbackFor = Exception.class)
    void context02(){
        LambdaUpdateWrapper<Student> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.eq(Student::getName,"张三")
                .set(Student::getName,"张三改");

        studentDao.update(Student.builder().build(), updateWrapper);
    }
}
```

可以看到这边做了一个简单的更新操作，然后进行操作时

{% asset_img 2022-02-12-16-22-47.png %}

此时观察数据库的确也没有被更新掉

只需要在测试方法上添加`@Rollback(false)`，我们试一试

{% asset_img 2022-02-12-16-39-25.png %}

运行结果

{% asset_img 2022-02-12-18-43-01.png %}

也算是一个小坑嘛，哈哈！
