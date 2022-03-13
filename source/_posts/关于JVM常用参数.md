---
title: 关于JVM常用参数
hide: false
tags:
  - Java面试
  - JVM
keywords:
  - Java面试
  - JVM
abbrlink: a72f470b
date: 2022-03-13 15:12:45
categories:
---

笔记链接： [大厂面试视频](https://blog.csdn.net/u011863024/article/details/114684428)

## `JVM`的标配参数和`X`参数

[官方文档](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html)

`JVM`的参数类型：
<!-- more -->

> 标配参数
- `-version java -version`
- `-help`

> `X`参数（了解）
- `-Xint`：解释执行
- `-Xcomp`：第一次使用就编译成本地代码
- `-Xmixed`：混合模式

## `VM`的`XX`参数之布尔类型
公式：`-XX:+` 或者 `-` 某个属性值（`+`表示开启，`-`表示关闭）

如何查看一个正在运行中的`java`程序，它的某个`jvm`参数是否开启？具体值是多少？
```java
jps -l 查看一个正在运行中的java程序，得到Java程序号。
jinfo -flag PrintGCDetails (Java程序号 )查看它的某个jvm参数（如PrintGCDetails ）是否开启。
jinfo -flags (Java程序号 )查看它的所有jvm参数
```
Case

> 是否打印`GC`收集细节
```java
-XX:-PrintGCDetails
-XX:+PrintGCDetails
```
> 是否使用串行垃圾回收器
```java
-XX:-UseSerialGC
-XX:+UserSerialGC
```

## `JVM`的`XX`参数之设值类型
公式：`-XX`:属性`key=`属性值`value`

Case
```java
-XX:MetaspaceSize=128m
-XX:MaxTenuringThreshold=15
```
## `VM`的`XX`参数之`XmsXmx`坑题
两个经典参数：
```java
-Xms等价于-XX:InitialHeapSize，初始大小内存，默认物理内存1/64
-Xmx等价于-XX:MaxHeapSize，最大分配内存，默认为物理内存1/4
```

## `JVM`盘点家底查看初始默认
> 查看初始默认参数值
```java
-XX:+PrintFlagsInitial
```

公式：`java -XX:+PrintFlagsInitial`

{% asset_img 2022-03-13-15-29-37.png %}

> 查看修改更新参数值
```java
-XX:+PrintFlagsFinal
```

公式：`java -XX:+PrintFlagsFinal`

{% asset_img 2022-03-13-15-32-07.png %}

**`=`表示默认，`:=`表示修改过的。**

## ``JVM``盘点家底查看修改变更值
`PrintFlagsFinal`举例，运行`java`命令的同时打印出参数
```java
java -XX:+PrintFlagsFinal -XX:MetaspaceSize=512m HelloWorld

--------------
...
   size_t MetaspaceSize                            := 536870912                               {pd product} {default}
...
```

> 打印命令行参数
```java
-XX:+PrintCommandLineFlags
```
```java
(base) ➜  ~ java -XX:+PrintCommandLineFlags -version

-XX:G1ConcRefinementThreads=8 -XX:GCDrainStackTargetSize=64 -XX:InitialHeapSize=268435456 -XX:MaxHeapSize=4294967296 -XX:+PrintCommandLineFlags -XX:ReservedCodeCacheSize=251658240 -XX:+SegmentedCodeCache -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseG1GC
java version "11.0.10" 2021-01-19 LTS
Java(TM) SE Runtime Environment 18.9 (build 11.0.10+8-LTS-162)
Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.10+8-LTS-162, mixed mode)
```

## 堆内存初始大小快速复习

`JDK 1.8`之后将最初的永久代取消了，由元空间取代。

{% asset_img 2022-03-13-15-48-45.png %}

在`Java8`中，永久代已经被移除，被一个称为元空间的区域所取代。元空间的本质和永久代类似。

元空间(`Java8`)与永久代(`Java7`)之间最大的区别在于：永久带使用的`JVM`的堆内存，但是`Java8`以后的元空间**并不在虚拟机中而是使用本机物理内存**。

因此，默认情况下，元空间的大小仅受本地内存限制。类的元数据放入`native memory`，字符串池和类的静态变量放入`java`堆中，这样可以加载多少类的元数据就不再由`MaxPermSize`控制，而由系统的实际可用空间来控制。
```java
public class JVMMemorySizeDemo {
    public static void main(String[] args) throws InterruptedException {
        // 返回Java虚拟机中内存的总量
        long totalMemory = Runtime.getRuntime().totalMemory();

        // 返回Java虚拟机中试图使用的最大内存量
        long maxMemory = Runtime.getRuntime().maxMemory();

        System.out.println(String.format("TOTAL_MEMORY(-Xms): %d B, %.2f MB.", totalMemory, totalMemory / 1024.0 / 1024));
        System.out.println(String.format("MAX_MEMORY(-Xmx): %d B, %.2f MB.", maxMemory, maxMemory / 1024.0 / 1024));
    }
}
```
输出结果：
{% asset_img 2022-03-13-15-51-39.png %}

## 常用基础参数栈内存`Xss`讲解

设置单个线程栈的大小，一般默认为`512k~1024K`

等价于`-XX:ThreadStackSize`

> -XX:ThreadStackSize=size
Sets the thread stack size (in bytes). Append the letter k or K to indicate kilobytes, m or M to indicate megabytes, g or G to indicate gigabytes. The default value depends on virtual memory.
The following examples show how to set the thread stack size to 1024 KB in different units:
-XX:ThreadStackSize=1m
-XX:ThreadStackSize=1024k
-XX:ThreadStackSize=1048576
This option is equivalent to `-Xss`. [文档](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html#BGBCIEFC)


## 常用基础参数元空间`MetaspaceSize`讲解

- `-Xmn`：设置年轻代大小
- `-XX:MetaspaceSize` 设置元空间大小

元空间的本质和永久代类似，都是对JVM规范中方法区的实现。不过元空间与永久代之间最大的区别在于：元空间并不在虚拟机中，而是使用本地内存。因此，默认情况下，元空间的大小仅受本地内存限制

典型设置案例
```java
-Xms128m -Xmx4096m -Xss1024k -XX:MetaspaceSize=512m -XX:+PrintCommandLineFlags -XX:+PrintGCDetails-XX:+UseSerialGC
```

## 常用基础参数`PrintGCDetails`回收前后对比讲解

`-XX:+PrintGCDetails` 输出详细`GC`收集日志信息

设置参数 `-Xms10m -Xmx10m -XX:+PrintGCDetails` 运行以下程序

```java
import java.util.concurrent.TimeUnit;

public class PrintGCDetailsDemo {

	
	public static void main(String[] args) throws InterruptedException {
		byte[] byteArray = new byte[10 * 1024 * 1024];
		
		TimeUnit.SECONDS.sleep(Integer.MAX_VALUE);
	}
}
```
输出结果：

```java
[GC (Allocation Failure) [PSYoungGen: 778K->480K(2560K)] 778K->608K(9728K), 0.0029909 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
[GC (Allocation Failure) [PSYoungGen: 480K->480K(2560K)] 608K->616K(9728K), 0.0007890 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
[Full GC (Allocation Failure) [PSYoungGen: 480K->0K(2560K)] [ParOldGen: 136K->518K(7168K)] 616K->518K(9728K), [Metaspace: 2644K->2644K(1056768K)], 0.0058272 secs] [Times: user=0.00 sys=0.00, real=0.01 secs] 
[GC (Allocation Failure) [PSYoungGen: 0K->0K(2560K)] 518K->518K(9728K), 0.0002924 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
[Full GC (Allocation Failure) [PSYoungGen: 0K->0K(2560K)] [ParOldGen: 518K->506K(7168K)] 518K->506K(9728K), [Metaspace: 2644K->2644K(1056768K)], 0.0056906 secs] [Times: user=0.01 sys=0.00, real=0.01 secs] 
Exception in thread "main" java.lang.OutOfMemoryError: Java heap space
	at com.lun.jvm.PrintGCDetailsDemo.main(PrintGCDetailsDemo.java:9)
Heap
 PSYoungGen      total 2560K, used 61K [0x00000000ffd00000, 0x0000000100000000, 0x0000000100000000)
  eden space 2048K, 3% used [0x00000000ffd00000,0x00000000ffd0f748,0x00000000fff00000)
  from space 512K, 0% used [0x00000000fff00000,0x00000000fff00000,0x00000000fff80000)
  to   space 512K, 0% used [0x00000000fff80000,0x00000000fff80000,0x0000000100000000)
 ParOldGen       total 7168K, used 506K [0x00000000ff600000, 0x00000000ffd00000, 0x00000000ffd00000)
  object space 7168K, 7% used [0x00000000ff600000,0x00000000ff67ea58,0x00000000ffd00000)
 Metaspace       used 2676K, capacity 4486K, committed 4864K, reserved 1056768K
  class space    used 285K, capacity 386K, committed 512K, reserved 1048576K
```

{% asset_img 2022-03-13-16-04-30.png %}

{% asset_img 2022-03-13-16-04-40.png %}

## 常用基础参数`SurvivorRatio`讲解

{% asset_img 2022-03-13-16-05-01.png %}

调节新生代中 `eden` 和 `S0、S1`的空间比例，默认为 `-XX:SuriviorRatio=8，Eden:S0:S1 = 8:1:1`

假如设置成 `-XX:SurvivorRatio=4`，则为 `Eden:S0:S1 = 4:1:1`

`SurvivorRatio`值就是设置`eden`区的比例占多少，`S0`和`S1`相同。


## 常用基础参数`NewRatio`讲解

配置年轻代`new`和老年代`old` 在堆结构的占比

默认：`-XX:NewRatio=2` 新生代占`1`，老年代`2`，年轻代占整个堆的`1/3`

`-XX:NewRatio=4：`新生代占`1`，老年代占`4`，年轻代占整个堆的`1/5`，

`NewRadio`值就是设置老年代的占比，剩下的`1`个新生代。

新生代特别小，会造成频繁的进行`GC`收集。

## 常用基础参数`MaxTenuringThreshold`讲解

晋升到老年代的对象年龄。

`SurvivorTo和SurvivorFrom`互换，原`SurvivorTo`成为下一次`GC`时的`SurvivorFrom`区，部分对象会在`From`和`To`区域中复制来复制去，如此交换`15`次（由`JVM`参数`MaxTenuringThreshold`决定，这个参数默认为`15`），最终如果还是存活，就存入老年代。

这里就是调整这个次数的，默认是15，并且设置的值 在 `0~15`之间。

`-XX:MaxTenuringThreshold=0`：设置垃圾最大年龄。如果设置为0的话，则年轻对象不经过`Survivor`区，直接进入老年代。对于年老代比较多的应用，可以提高效率。如果将此值设置为一个较大的值，则年轻代对象会在`Survivor`区进行多次复制，这样可以增加对象再年轻代的存活时间，增加在年轻代即被回收的概念。










