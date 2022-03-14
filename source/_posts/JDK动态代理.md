---
title: JDK动态代理原理剖析(简洁版)
hide: false
abbrlink: dfdc2005
date: 2022-03-14 17:40:52
tags:
- JDK
- 动态代理
- Java面试
categories:
keywords:
- JDK
- 动态代理
- Java面试
---

## 动态代理两个实例(视频中学的)
动态代理在`Java`中有着广泛的应用，比如`Spring AOP、Hibernate`数据查询、测试框架的后端`mock、RPC`远程调用、`Java`注解对象获取、日志、用户鉴权、全局性异常处理、性能监控，甚至事务处理等。
本文主要介绍`Java`中两种常见的动态代理方式：`JDK`原生动态代理和`CGLIB`动态代理。



### 代理模式
本文将介绍的`Java`动态代理与设计模式中的代理模式有关，什么是代理模式呢？

<!-- more -->

**代理模式：**给某一个对象提供一个代理，并由代理对象来控制对真实对象的访问。代理模式是一种结构型设计模式。

代理模式角色分为 `3` 种：

- `Subject（抽象主题角色）`：定义代理类和真实主题的公共对外方法，也是代理类代理真实主题的方法；

- `RealSubject（真实主题角色）`：真正实现业务逻辑的类；

- `Proxy（代理主题角色）`：用来代理和封装真实主题；

代理模式的结构比较简单，其核心是代理类，为了让客户端能够一致性地对待真实对象和代理对象，在代理模式中引入了抽象层


{% asset_img 2022-03-14-17-42-04.png %}

> 代理模式按照职责（使用场景）来分类，至少可以分为以下几类：
```java
1、远程代理。 
2、虚拟代理。 
3、Copy-on-Write 代理。 
4、保护（Protect or Access）代理。 
5、Cache代理。 
6、防火墙（Firewall）代理。 
7、同步化（Synchronization）代理。 
8、智能引用（Smart Reference）代理等等。
```

如果根据字节码的创建时机来分类，可以分为静态代理和动态代理：

- 所谓静态也就是在程序运行前就已经存在代理类的字节码文件，代理类和真实主题角色的关系在运行前就确定了。
- 而动态代理的源码是在程序运行期间由`JVM`根据反射等机制动态的生成，所以在运行前并不存在代理类的字节码文件

### 静态代理

我们先通过实例来学习静态代理，然后理解静态代理的缺点，再来学习本文的主角：动态代理

编写一个接口 `UserService` ，以及该接口的一个实现类 `UserServiceImpl`

```java
public interface UserService {
    public void select();   
    public void update();
}

public class UserServiceImpl implements UserService {  
    public void select() {  
        System.out.println("查询 selectById");
    }
    public void update() {
        System.out.println("更新 update");
    }
}
```
我们将通过静态代理对 `UserServiceImpl` 进行功能增强，在调用 `select` 和 `update` 之前记录一些日志。写一个代理类 `UserServiceProxy`，代理类需要实现 `UserService`
```java
public class UserServiceProxy implements UserService {
    private UserService target; // 被代理的对象

    public UserServiceProxy(UserService target) {
        this.target = target;
    }
    public void select() {
        before();
        target.select();    // 这里才实际调用真实主题角色的方法
        after();
    }
    public void update() {
        before();
        target.update();    // 这里才实际调用真实主题角色的方法
        after();
    }

    private void before() {     // 在执行方法之前执行
        System.out.println(String.format("log start time [%s] ", new Date()));
    }
    private void after() {      // 在执行方法之后执行
        System.out.println(String.format("log end time [%s] ", new Date()));
    }
}
```
客户端测试
```java
public class Client1 {
    public static void main(String[] args) {
        UserService userServiceImpl = new UserServiceImpl();
        UserService proxy = new UserServiceProxy(userServiceImpl);

        proxy.select();
        proxy.update();
    }
}
```
通过静态代理，我们达到了功能增强的目的，而且没有侵入原代码，这是静态代理的一个优点。

#### 静态代理的缺点

虽然静态代理实现简单，且不侵入原代码，但是，当场景稍微复杂一些的时候，静态代理的缺点也会暴露出来。
1、 当需要代理多个类的时候，由于代理对象要实现与目标对象一致的接口，有两种方式：

    - 只维护一个代理类，由这个代理类实现多个接口，但是这样就导致代理类过于庞大
    - 新建多个代理类，每个目标对象对应一个代理类，但是这样会产生过多的代理类

2、 当接口需要增加、删除、修改方法的时候，目标对象与代理类都要同时修改，不易维护

### 如何改进？
当然是让代理类**动态的生成**啦，也就是动态代理。

**为什么类可以动态的生成？**

这就涉及到`Java`虚拟机的**类加载机制**了，推荐翻看《深入理解Java虚拟机》7.3节 类加载的过程。

Java虚拟机类加载过程主要分为五个阶段：加载、验证、准备、解析、初始化。其中加载阶段需要完成以下3件事情：

通过一个类的全限定名来获取定义此类的二进制字节流
将这个字节流所代表的静态存储结构转化为方法区的运行时数据结构
在内存中生成一个代表这个类的 java.lang.Class 对象，作为方法区这个类的各种数据访问入口

由于虚拟机规范对这3点要求并不具体，所以实际的实现是非常灵活的，关于第1点，获取类的二进制字节流（class字节码）就有很多途径：

从ZIP包获取，这是JAR、EAR、WAR等格式的基础
从网络中获取，典型的应用是 Applet
运行时计算生成，这种场景使用最多的是动态代理技术，在 java.lang.reflect.Proxy 类中，就是用了 ProxyGenerator.generateProxyClass 来为特定接口生成形式为 *$Proxy 的代理类的二进制字节流
由其它文件生成，典型应用是JSP，即由JSP文件生成对应的Class类
从数据库中获取等等

所以，动态代理就是想办法，根据接口或目标对象，计算出代理类的字节码，然后再加载到JVM中使用。但是如何计算？如何生成？情况也许比想象的复杂得多，我们需要借助现有的方案。

### 常见的字节码操作类库

这里有一些介绍：[java-source.net/open-source…](https://link.juejin.cn/?target=https%3A%2F%2Fjava-source.net%2Fopen-source%2Fbytecode-libraries)

### 实现动态代理的思考方向
为了让生成的代理类与目标对象（真实主题角色）保持一致性，从现在开始将介绍以下两种最常见的方式：

- 通过实现接口的方式 -> `JDK`动态代理
- 通过继承类的方式 -> `CGLIB`动态代理

注：使用`ASM`对使用者要求比较高，使用`Javassist`会比较麻烦

### `JDk`动态代理

JDK动态代理主要涉及两个类：`java.lang.reflect.Proxy` 和 `java.lang.reflect.InvocationHandler`，我们仍然通过案例来学习

编写一个调用逻辑处理器 `LogHandler` 类，提供日志增强功能，并实现 `InvocationHandler` 接口；在 `LogHandler` 中维护一个目标对象，这个对象是被代理的对象（真实主题角色）；在 `invoke` 方法中编写方法调用的逻辑处理
```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.util.Date;

/**
 * @author jinmao
 * @create 2022-03-14-10:52
 * @ClassName LogHandler
 * @Version 1.0
 * @Description
 */
public class LogHandler implements InvocationHandler {

    /**
     * 代理的对象，实际的方法执行者
     */
    private Object target;

    /**
     * 构造方法注入
     * @param target
     */
    public LogHandler(Object target){
        this.target = target;
    }

    /**
     * @param proxy:代理类代理的真实代理对象com.sun.proxy.$Proxy0
     * @param method:我们所要调用某个对象真实的方法的Method对象
     * @param args:指代代理对象方法传递的参数
     */
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        before();
        //调用target的method方法
        Object result = method.invoke(target, args);
        after();
        return result;
    }

    // 调用invoke方法之前执行
    private void before() {
        System.out.printf("log start time [%s] %n", new Date());
    }
    // 调用invoke方法之后执行
    private void after() {
        System.out.printf("log end time [%s] %n", new Date());
    }

}
```
编写客户端，获取动态生成的代理类的对象须借助 `Proxy` 类的 `newProxyInstance` 方法，具体步骤可见代码和注释

```java
import com.cy.learn.dynamic.proxy.utils.ProxyUtils;
import java.lang.reflect.Proxy;
/**
 * @creator jinmao
 * @create 2022-03-14-13:14
 * @ClassName Client
 * @Version 1.0
 * @Description
 */
public class Client {
    public static void main(String[] args) {
        // 设置变量可以保存动态代理类，默认名称以 $Proxy0 格式命名
        // System.getProperties().setProperty("sun.misc.ProxyGenerator.saveGeneratedFiles", "true");
        // 1. 创建被代理的对象，UserService接口的实现类
        UserServiceImpl userServiceImpl = new UserServiceImpl();
        // 2. 获取对应的 ClassLoader
        ClassLoader classLoader = userServiceImpl.getClass().getClassLoader();
        // 3. 获取所有接口的Class，这里的UserServiceImpl只实现了一个接口UserService，
        Class<?>[] interfaces = userServiceImpl.getClass().getInterfaces();
        // 4. 创建一个将传给代理类的调用请求处理器，处理所有的代理对象上的方法调用
        LogHandler logHandler = new LogHandler(userServiceImpl);
        /*
        5.根据上面提供的信息，创建代理对象 在这个过程中，
           a.JDK会通过根据传入的参数信息动态地在内存中创建和.class 文件等同的字节码
           b.然后根据相应的字节码转换成对应的class，
           c.然后调用newInstance()创建代理实例
         */
        UserService proxy = (UserService) Proxy.newProxyInstance(classLoader, interfaces, logHandler);
        // 调用代理的方法
        proxy.select();
        proxy.update();
        // 保存JDK动态代理生成的代理类，类名保存为 UserServiceProxy
        //ProxyUtils.generateClassFile(userServiceImpl.getClass(), "UserServiceProxy");
    }
}
```
运行结果
```java
log start time [Mon Mar 14 18:02:11 CST 2022] 
查询 selectById
log end time [Mon Mar 14 18:02:11 CST 2022] 
log start time [Mon Mar 14 18:02:11 CST 2022] 
更新 update
log end time [Mon Mar 14 18:02:11 CST 2022] 
```
`InvocationHandler` 和 `Proxy` 的主要方法介绍如下：

**`java.lang.reflect.InvocationHandler`**

```
Object invoke(Object proxy, Method method, Object[] args) 定义了代理对象调用方法时希望执行的动作，用于集中处理在动态代理类对象上的方法调用
```

**`java.lang.reflect.Proxy`**
```
static InvocationHandler getInvocationHandler(Object proxy)  用于获取指定代理对象所关联的调用处理器
static Class<?> getProxyClass(ClassLoader loader, Class<?>... interfaces) 返回指定接口的代理类
static Object newProxyInstance(ClassLoader loader, Class<?>[] interfaces, InvocationHandler h) 构造实现指定接口的代理类的一个新实例，所有方法会调用给定处理器对象的 invoke 方法
static boolean isProxyClass(Class<?> cl) 返回 cl 是否为一个代理类
```
### 代理类的调用过程

生成的代理类到底长什么样子呢？借助下面的工具类，把代理类保存下来再探个究竟

（通过设置环境变量`sun.misc.ProxyGenerator.saveGeneratedFiles=true`也可以保存代理类）

手写一个工具类:

```java
import sun.misc.ProxyGenerator;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * @creator jinmao
 * @create 2022-03-14-13:24
 * @ClassName ProxyUtils
 * @Version 1.0
 * @Description
 */
public class ProxyUtils {
    /**
     * 将根据类信息动态生成的二进制字节码保存到硬盘中，默认的是clazz目录下
     * @param clazz: 需要生成动态代理类的类
     * @param proxyName: 为动态生成的代理类的名称
     */
    public static void generateClassFile(Class clazz, String proxyName) {
        // 根据类信息和提供的代理类名称，生成字节码
        byte[] classFile = ProxyGenerator.generateProxyClass(proxyName, clazz.getInterfaces());
        String paths = clazz.getResource(".").getPath();
        System.out.println(paths);
        FileOutputStream out = null;
        try {
            //保留到硬盘中
            out = new FileOutputStream(paths + proxyName + ".class");
            out.write(classFile);
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                out.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
```

将这两行注释放开即可:
{% asset_img 2022-03-14-18-10-35.png %}

运行结果:
```java
log start time [Mon Mar 14 18:25:57 CST 2022] 
查询 selectById
log end time [Mon Mar 14 18:25:57 CST 2022] 
log start time [Mon Mar 14 18:25:57 CST 2022] 
更新 update
log end time [Mon Mar 14 18:25:57 CST 2022] 
```


`IDEA` 再次运行之后就可以在 `out` 的类路径下找到 `UserServiceProxy.class`，双击后`IDEA`的反编译插件会将该二进制`class`文件

{% asset_img 2022-03-14-18-12-41.png %}

`UserServiceProxy`的反编译代码:

```java
//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

import com.cy.learn.dynamic.proxy.UserService;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.lang.reflect.UndeclaredThrowableException;

public final class UserServiceProxy extends Proxy implements UserService {
    private static Method m1;
    private static Method m2;
    private static Method m4;
    private static Method m0;
    private static Method m3;

    public UserServiceProxy(InvocationHandler var1) throws  {
        super(var1);
    }

    public final boolean equals(Object var1) throws  {
        ...
    }

    public final String toString() throws  {
        ...
    }

    public final void select() throws  {
        try {
            super.h.invoke(this, m4, (Object[])null);
        } catch (RuntimeException | Error var2) {
            throw var2;
        } catch (Throwable var3) {
            throw new UndeclaredThrowableException(var3);
        }
    }

    public final int hashCode() throws  {
        ...
    }

    public final void update() throws  {
        try {
            super.h.invoke(this, m3, (Object[])null);
        } catch (RuntimeException | Error var2) {
            throw var2;
        } catch (Throwable var3) {
            throw new UndeclaredThrowableException(var3);
        }
    }

    static {
        try {
            m1 = Class.forName("java.lang.Object").getMethod("equals", Class.forName("java.lang.Object"));
            m2 = Class.forName("java.lang.Object").getMethod("toString");
            m4 = Class.forName("com.cy.learn.dynamic.proxy.UserService").getMethod("select");
            m0 = Class.forName("java.lang.Object").getMethod("hashCode");
            m3 = Class.forName("com.cy.learn.dynamic.proxy.UserService").getMethod("update");
        } catch (NoSuchMethodException var2) {
            throw new NoSuchMethodError(var2.getMessage());
        } catch (ClassNotFoundException var3) {
            throw new NoClassDefFoundError(var3.getMessage());
        }
    }
}
```
其中看一段我们自己的和新方法`select()`:
```java
public final void select() throws  {
    try {
        super.h.invoke(this, m4, (Object[])null);
    } catch (RuntimeException | Error var2) {
        throw var2;
    } catch (Throwable var3) {
        throw new UndeclaredThrowableException(var3);
    }
}
```
此处的`super`就是`extends`的`Proxy`类,我们来看`super`中的`h`到底是什么?

{% asset_img 2022-03-14-18-24-12.png %}

而`super.h.invoke`方法即为我们手写的`LogHandler`中的`invoke`方法,所以日志才会打印

{% asset_img 2022-03-14-18-25-17.png %}

> 小总结

从 `UserServiceProxy` 的代码中我们可以发现：

- `UserServiceProxy` 继承了 `Proxy` 类，并且实现了被代理的所有接口，以及`equals、hashCode、toString`等方法
- 由于 `UserServiceProxy` 继承了 `Proxy` 类，所以每个代理类都会关联一个 `InvocationHandler` 方法调用处理器
- 类和所有方法都被 `public final` 修饰，所以代理类只可被使用，不可以再被继承
- 每个方法都有一个 `Method` `对象来描述，Method` 对象在`static`静态代码块中创建，以` m + 数字` 的格式命名
- 调用方法的时候通过 `super.h.invoke(this, m1, (Object[])null)`; 调用，其中的 `super.h.invoke` 实际上是在创建代理的时候传递给 `Proxy.newProxyInstance` 的 `LogHandler` 对象，它继承 `InvocationHandler` 类，负责实际的调用处理逻辑

而 `LogHandler` 的 `invoke` 方法接收到 `method、args` 等参数后，进行一些处理，然后通过反射让被代理的对象 `target` 执行方法

JDK动态代理执行方法调用的过程简图如下：

{% asset_img 2022-03-14-18-28-41.png %}










