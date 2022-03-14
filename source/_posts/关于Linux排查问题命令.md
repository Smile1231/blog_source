---
title: 关于Linux排查问题命令
hide: false
tags:
  - Java面试
  - Linux
keywords:
  - Java面试
  - Linux
abbrlink: 56be7cc9
date: 2022-03-13 15:13:24
categories:
---

## `Linux`命令之`top`

> top - 整机性能查看

<!-- more -->

{% asset_img 2022-03-13-22-54-06.png %}

{% asset_img 2022-03-13-22-58-37.png %}

主要看`load average, CPU, MEN`三部分

- `load average`表示系统负载，即任务队列的平均长度。 三个数值分别为 `1`分钟、`5`分钟、`15`分钟前到现在的平均值。
- `load average`: 如果这个数除以逻辑`CPU`的数量，结果高于`5`的时候就表明系统在超负荷运转了。

[`Linux`中`top`命令参数详解](https://yjclsx.blog.csdn.net/article/details/81508455)


> uptime - 系统性能命令的精简版


{% asset_img 2022-03-13-23-00-56.png %}

## `Linux`之`cpu`查看`vmstat` (`mac`中为`vm_stat`)

{% asset_img 2022-03-13-23-05-38.png %}

- `procs`
    - `r`：运行和等待的`CPU`时间片的进程数，原则上`1`核的`CPU`的运行队列不要超过`2`，整个系统的运行队列不超过总核数的2倍，否则代表系统压力过大，我们看蘑菇博客测试服务器，能发现都超过了`2`，说明现在压力过大
    - `b`：等待资源的进程数，比如正在等待磁盘`I/O`、网络`I/O`等
- `cpu`
    `us`：用户进程消耗`CPU`时间百分比，`us`值高，用户进程消耗`CPU`时间多，如果长期大于`50%`，优化程序
    `sy`：内核进程消耗的CPU时间百分比
    `us + sy `参考值为`80%`，如果`us + sy` 大于`80%`，说明可能存在`CPU`不足，从上面的图片可以看出，`us + sy`还没有超过百分80，因此说明蘑菇博客的`CPU`消耗不是很高
    `id`：处于空闲的`CPU`百分比
    `wa`：系统等待`IO`的`CPU`时间百分比
    `st`：来自于一个虚拟机偷取的`CPU`时间比

## `Linux`之`cpu`查看`pidstat`（`Mac`中没有）

查看看所有`cpu`核信息
```linux
mpstat -P ALL 2
```

{% asset_img 2022-03-13-23-10-51.png %}


每个进程使用`cpu`的用量分解信息
```linux
pidstat -u 1 -p 进程编号
```
{% asset_img 2022-03-13-23-11-14.png %}



## `Linux`之内存查看`free`和`pidstat`（`Mac`中没有）

应用程序可用内存数

经验值

应用程序可用内存l系统物理内存>`70%`内存充足

应用程序可用内存/系统物理内存<`20%`内存不足，需要增加内存

`20%`<应用程序可用内存/系统物理内存<`70%`内存基本够用

`m/g`：兆/吉
{% asset_img 2022-03-13-23-12-13.png %}

查看额外
```linux
pidstat -p 进程号 -r 采样间隔秒数
```

## `Linux`之硬盘查看`df`

查看磁盘剩余空间数

{% asset_img 2022-03-13-23-13-22.png %}

## `Linux`之磁盘`IO`查看`iostat`和`pidstat`

磁盘`I/O`性能评估
`mac`:
{% asset_img 2022-03-13-23-16-06.png %}

`linux`:
{% asset_img 2022-03-13-23-16-54.png %}

磁盘块设备分布

- `rkB/s`每秒读取数据量`kB;wkB/s`每秒写入数据量`kB`;
- `svctm lO`请求的平均服务时间，单位毫秒;
- `await l/O`请求的平均等待时间，单位毫秒;值越小，性能越好;
- `util`一秒中有百分几的时间用于`I/O`操作。接近`100%`时，表示磁盘带宽跑满，需要优化程序或者增加磁盘;
- `rkB/s、wkB/s`根据系统应用不同会有不同的值，但有规律遵循:长期、超大数据读写，肯定不正常，需要优化程序读取。
- `svctm`的值与`await`的值很接近，表示几乎没有IO等待，磁盘性能好。
- 如果`await`的值远高于`svctm`的值，则表示`IO`队列等待太长，需要优化程序或更换更快磁盘。

## `Linux`之网络`IO`查看`ifstat`

默认本地没有，下载`ifstat`
```shell
wget http://gael.roualland.free.fr/lifstat/ifstat-1.1.tar.gz
tar -xzvf ifstat-1.1.tar.gz
cd ifstat-1.1
./configure
make
make install
```
查看网络`IO`

各个网卡的`in、out`

观察网络负载情况程序

网络读写是否正常

- 程序网络`I/O`优化
- 增加网络`I/O`带宽

{% asset_img 2022-03-13-23-19-52.png %}

## `Linux`查看物理`CPU`个数、核数、逻辑`CPU`个数
```bash
# 总核数 = 物理CPU个数 X 每颗物理CPU的核数 
# 总逻辑CPU数 = 物理CPU个数 X 每颗物理CPU的核数 X 超线程数

# 查看物理CPU个数
cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l

# 查看每个物理CPU中core的个数(即核数)
cat /proc/cpuinfo| grep "cpu cores"| uniq

# 查看逻辑CPU的个数 , 这是我们关心的,涉及到线程池大小
cat /proc/cpuinfo| grep "processor"| wc -l
```

> 查看服务器信息指令

```bash
#查看CPU信息（型号）
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c

#查看内存信息
cat /proc/meminfo

#如何查看Linux 内核
uname -a
cat /proc/version

#查看机器型号（机器硬件型号）
dmidecode | grep "Product Name"
dmidecode

#如何查看linux 系统版本
cat /etc/redhat-release
lsb_release -a
cat  /etc/issue
 
#如何查看linux系统和CPU型号，类型和大小
cat /proc/cpuinfo

#如何查看linux 系统内存大小的信息，可以查看总内存，剩余内存，可使用内存等信息  
cat /proc/meminfo
```



## `CPU`占用过高的定位分析思路

结合`Linux`和`JDK`命令一块分析

案例步骤

- 先用`top`命令找出`CPU`占比最高的

{% asset_img 2022-03-13-23-20-27.png %}

- `ps -ef`或者`jps`进一步定位，得知是一个怎么样的一个后台程序作搞屎棍
{% asset_img 2022-03-13-23-24-51.png %}

- 定位到具体线程或者代码
    - `ps -mp` 进程 `-o THREAD,tid,time`
    - `-m` 显示所有的线程
    - `-p pid`进程使用`cpu`的时间
    - `-o` 该参数后是用户自定义格式

{% asset_img 2022-03-13-23-25-31.png %}

- 将需要的线程`ID`转换为`16`进制格式（英文小写格式），命令`printf %x 172 `将`172`转换为十六进制
- `jstack 进程ID | grep tid`（`16`进制线程`ID`小写英文）`-A60`

> ps - process status
-A Display information about other users’ processes, including those without controlling terminals.
-e Identical to -A.
-f Display the uid, pid, parent pid, recent CPU usage, process start time, controlling tty, elapsed CPU usage, and the associated command. If the -u option is also used, display the user name rather then the numeric uid. When -o or -O is used to add to the display following -f, the command field is not truncated as severely as it is in other formats.
[ps -ef中的e、f是什么含义](https://blog.csdn.net/lzufeng/article/details/83537275)



对于`JDK`自带的`JVM`监控和性能分析工具用过哪些?一般你是怎么用的?[link](https://blog.csdn.net/u011863024/article/details/106651068)


## `GitHub`骚操作之`awesome`搜索
- 公式：`awesome` 关键字：`awesome`系列，一般用来收集学习、工具、书籍类相关的项目
- 搜索优秀的`redis`相关的项目，包括框架，教程等 `awesome redis`
## `GitHub`骚操作之`#L`数字
一行：地址后面紧跟 `#L10`
 `https://github.com/abc/abc/pom.xml#L13`
多行：地址后面紧跟 `#Lx - #Ln`
`https://github.com/moxi624/abc/abc/pom.xml#L13-L30`
## `GitHub`骚操作之`T`搜索

{% asset_img 2022-03-13-23-31-47.png %}