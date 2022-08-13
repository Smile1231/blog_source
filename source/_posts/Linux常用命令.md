---
title: Linux常用命令
hide: false
tags: Linux
abbrlink: d0edc1ed
date: 2022-06-29 22:06:39
categories:
keywords:
---

##  `Linux`查看空间大小的命令

<!-- more -->

### `df`
```bash
第一列：文件系统
第二列：容量
第三列：已用容量
第四列：可用容量
第五列：已用容量%
第六列：挂载点
```

{% asset_img 2022-06-29-22-09-03.png %}

参数
```bash
-a: 显示所有文件系统信息，包括系统特有的 /proc、/sysfs 等文件系统；
-m: 以 MB 为单位显示容量；
-k: 以 KB 为单位显示容量，默认以 KB 为单位；
-h: 使用人们习惯的 KB、MB 或 GB 等单位自行显示容量；
-T: 显示该分区的文件系统名称；
-i: 不用硬盘容量显示，而是以含有 inode 的数量来显示。
--block-size=<区块大小>：以指定的区块大小来显示区块数目；
-l或--local：仅显示本地端的文件系统；
--no-sync：在取得磁盘使用信息前，不要执行sync指令，此为预设值；
-P或--portability：使用POSIX的输出格式；
--sync：在取得磁盘使用信息前，先执行sync指令；
-t<文件系统类型>或--type=<文件系统类型>：仅显示指定文件系统类型的磁盘信息；
-x<文件系统类型>或--exclude-type=<文件系统类型>：不要显示指定文件系统类型的磁盘信息；
--help：显示帮助；
--version：显示版本信息。
```
{% asset_img 2022-06-29-22-17-18.png %}

### `du`

{% asset_img 2022-06-29-22-20-51.png %}

> 如果只想查看当前目录占用空间的大小，不查看子目录或者子文件占用空间大小，那么`s`选项无疑很有帮助，如下：
```
du -sh
```
{% asset_img 2022-06-29-22-23-40.png %}

```bash
du -h --max-depth=0
```
{% asset_img 2022-06-29-22-29-35.png %}

## `Mount`文件挂载

> 文件系统挂载

硬件设备必须挂载之后才能使用，只不过，有些硬件设备（比如硬盘分区）在每次系统启动时会自动挂载，而有些（比如 U 盘、光盘）则需要手动进行挂载。

挂载指的是将硬件设备的文件系统和 `Linux` 系统中的文件系统，通过指定目录（作为挂载点）进行关联。而要将文件系统挂载到 `Linux` 系统上，就需要使用 `mount` 挂载命令。

> `mount` 命令的常用格式有以下几种：

```bash
mount [-l]
# 单纯使用 `mount` 命令，会显示出系统中已挂载的设备信息，使用 `-l` 选项，会额外显示出卷标名称（读者可自行运行，查看输出结果）；

mount -a
# -a 选项的含义是自动检查 /etc/fstab 文件中有无疏漏被挂载的设备文件，如果有，则进行自动挂载操作。这里简单介绍一下 /etc/fstab 文件，此文件是自动挂载文件，系统开机时会主动读取 /etc/fstab 这个文件中的内容，根据该文件的配置，系统会自动挂载指定设备。

mount [-t 系统类型] [-L 卷标名] [-o 特殊选项] [-n] 设备文件名 挂载点

# 各选项的含义分别是：

# -t 系统类型：指定欲挂载的文件系统类型。Linux 常见的支持类型有 EXT2、EXT3、EXT4、iso9660（光盘格式）、vfat、reiserfs 等。如果不指定具体类型，挂载时 Linux 会自动检测。
# -L 卷标名：除了使用设备文件名（例如 /dev/hdc6）之外，还可以利用文件系统的卷标名称进行挂载。
# -n：在默认情况下，系统会将实际挂载的情况实时写入 /etc/mtab 文件中，但在某些场景下（例如单人维护模式），为了避免出现问题，会刻意不写入，此时就需要使用这个选项；
# -o 特殊选项：可以指定挂载的额外选项，比如读写权限、同步/异步等，如果不指定，则使用默认值（defaults）。
```
> mount 命令选项及功能

```bash
rw/ro ：是否对挂载的文件系统拥有读写权限，rw 为默认值，表示拥有读写权限；ro 表示只读权限。

async/sync ： 此文件系统是否使用同步写入（sync）或异步（async）的内存机制，默认为异步 async。

dev/nodev ：是否允许从该文件系统的 block 文件中提取数据，为了保证数据安装，默认是 nodev。

auto/noauto ：是否允许此文件系统被以 mount -a 的方式进行自动挂载，默认是 auto。

suid/nosuid ：设定文件系统是否拥有 SetUID 和 SetGID 权限，默认是拥有。

exec/noexec ：设定在文件系统中是否允许执行可执行文件，默认是允许。

user/nouser ：设定此文件系统是否允许让普通用户使用 mount 执行实现挂载，默认是不允许（nouser），仅有 root 可以。

defaults ：定义默认值，相当于 rw、suid、dev、exec、auto、nouser、async 这 7 个选项。

remount重新挂载已挂载的文件系统，一般用于指定修改特殊权限。
```


## 查看系统信息

```bash
cat /etc/os-release
```
{% asset_img 2022-06-30-10-12-30.png %}

### 查看内核版本
```linux
cat /proc/version
uname -a
uname -r
```
{% asset_img 2022-08-06-10-40-55.png %}

### 查看`linux`版本信息
```linux
lsb_release -a
cat /etc/issue
```
{% asset_img 2022-08-06-10-42-19.png %}

### 查看`linux`是`64`为还是`32`位
```linux
getconf LONG_BIT
file /bin/ls
```
{% asset_img 2022-08-06-10-43-41.png %}

### 直接查看系统的架构
```linux
dpkg --print-architecture
arch
file /lib/systemd/systemd
```
{% asset_img 2022-08-06-10-45-09.png %}


## 查看开放端口

```bash
netstat -lntu 
或者  ss -lntu
```
```bash
查看端口号
netstat -ntlp //查看当前所有tcp端口·
netstat -ntulp |grep 6666 //查看所有1935端口使用情况·
CentOS默认开放的本地端口范围
系统本地开放端口的范围：（默认30000多到60000多）
```

{% asset_img 2022-06-30-10-13-53.png %}

## 检查端口是否打开
```bash
netstat -na | grep :9999
ss -na | grep :9999
```
输出必须保持空白，从而验证它当前未被使用，以便我们可以将端口规则手动添加到系统`iptables`防火墙。

## `centos`查看防火墙状态的方法
```bash
service iptables status #查看iptables防火墙状态
或
systemctl status firewalld #查看firewall防火墙服务状态

#iptables防火墙
service iptables start #启动防火墙
service iptables stop #停止防火墙
service iptables restart #重启防火墙
#firewall防火墙
service firewalld start # 开启
service firewalld stop # 关闭 
service firewalld restart # 重启
```

## 开放端口
```bash
# 需要root权限
firewall-cmd --zone=public --add-port=80/tcp --permanent
# 命令含义：
--zone #作用域
--add-port=6666/tcp #添加端口，格式为：端口/通讯协议
--permanent #永久生效，没有此参数重启后失效
```

## 防火墙`firewall`

```bash
# 重启firewall
firewall-cmd --reload

# 检查是否生效
firewall-cmd --zone=public —query-port=8080/tcp

# 停止firewall
systemctl stop firewalld.service

# 禁止firewall开机启动
systemctl disable firewalld.service
```

## 检测远程端口是否打开

```bash
telnet 118.10.6.128 88
# 测试远程主机端口是否打开
```

```bash
nmap ip -p port #测试端口
nmap ip 
# 根据显示close/open确定端口是否打开
```
{% asset_img 2022-07-01-09-13-27.png %}

## `Linux`生成 `UUID`
```bash
cat /proc/sys/kernel/random/uuid
```

## 查看正在运行的`java`线程
```bash
jps -l

## 杀死线程
kill -9 <PID>
```

## `linux shell` 缺少 `ps` 命令

1. 缺少 `ps` 命令
```bash
apt-get install -y procps
yum install -y procps
```
2. 缺少 `pstree` 命令
```bash
apt-get install -y psmisc
yum install -y psmisc
```
3. 出现找不到包的问题：
{% asset_img 2022-08-08-11-51-34.png %}
更新一下就可以了：
```bash
apt-get update
```
