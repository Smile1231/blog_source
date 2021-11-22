---
title: ubuntu20无法安装vmtools解决
hide: false
tags:
  - ubuntu
  - 虚拟机
categories: Ubuntu
keywords: ubuntu
abbrlink: 6e65ed30
date: 2021-11-22 17:05:19
---

使用`vmware`安装`Ubuntu 20 LTS` 后 `vmware tools`工具选项为灰色，不允许安装，也无法共享文件夹问题。

{% asset_img 2021-11-22-17-07-07.png %}

<!-- more -->

`lsb_release -a`查看当前`Ubutun`版本。

## 解决办法：
1. 在`vmware`安装目录下找到`linux.iso`文件

{% asset_img 2021-11-22-17-09-52.png %}

2. 使用光盘挂接方式挂接到当前虚拟机。

{% asset_img 2021-11-22-17-30-17.png %}
3. 将会在虚拟机内看到一个`DVD`显示为`VMWare Tools`。

{% asset_img 2021-11-22-17-30-49.png %}
4. 进入到目标目录下并进入终端
{% asset_img 2021-11-22-17-31-56.png %}
{% asset_img 2021-11-22-17-32-26.png %}
5. 进行解压 `tar -zxvf VMwareTools…tar.gz`
在解压文件夹下`sudo ./vmware-install.pl`

7 都选择默认，一路回车安装完成。

8 最后在`mnt`文件夹下就会看到`hgfs`文件了，就可以实现和`Windows`文件共享了。

{% asset_img 2021-11-22-17-33-55.png %}




## 共享文件夹不存在解决办法
```linux
sudo vmhgfs-fuse .host:/ /mnt/hgfs/ -o allow_other -o uid=1000
```

## 使用`apt`无法定文软件版解决方案
```bash
#备份sources.list文件
sudo cp  /etc/apt/sources.list /etc/apt/sources.list.bak
#打开sources.list文件
sudo vim  /etc/apt/sources.list
#删除原内容，添加下列内容
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
#保存 做完以上前期工作，正式安装yum
sudo apt-get update
sudo apt install yum
#成功解决上楼报错
```
## `Ubuntu 20 04` 提示“检测到系统程序出现问题”解决
```bash
sudo vi /etc/default/apport
# 将enabled=0
enabled=0
```










