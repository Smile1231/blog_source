---
title: The Basic knowledge of Anaconda
hide: false
tags: master
categories: master
keywords: master
abbrlink: 378107f2
date: 2022-05-23 16:16:39
---


# ``Anaconda``基本学习

`conda`中想要安装的包，可以在这个网站搜索查询： https://anaconda.org/search?q=fastq-join


>  官网下载  [链接](https://link.jianshu.com/?t=https%3A%2F%2Fwww.anaconda.com%2Fdownload%2F)

此处不多说


> 环境变量的配置(windows)

需要注意的是,``AnaConda``需要配置三个路径的环境变量

<!-- more -->

{% asset_img 2022-05-23-16-19-09.png %}

根据自己的安装目录为准

此时在``windows``中的``cmd``中输入``conda``命令

{% asset_img 2022-05-23-16-19-17.png %}

说明安装完毕,就可以投入使用了

## ``Conda``的基本指令

### 环境管理
```python
# 升级conda
conda update conda
conda update anaconda
conda update anaconda-navigator    #update最新版本的anaconda-navigator
conda update xxx   #更新xxx文件包

conda --version #获取版本号

conda update --help
conda remove --help  #查看某一命令的帮助，如update命令及remove命令

conda env -h # 查看环境管理的全部命令帮助

conda create --name your_env_name #创建环境 --name可以省略为-n

conda create --n your_env_name python=3.7#创建制定python版本的环境

conda create --name your_env_name numpy scipy#创建包含某些包的环境

conda info --envs
conda env list  #列举当前所有环境

#进入某个环境
activate your_env_name

#退出当前环境
deactivate 

#复制某个环境
conda create --name new_env_name --clone old_env_name 

#删除某个环境
conda remove --name your_env_name --all

```

### 分享环境
```python
# 如果你想把你当前的环境配置与别人分享，这样ta可以快速建立一个与你一模一样的环境（同一个版本的python及各种包）来共同开发/进行新的实验。一个分享环境的快速方法就是给ta一个你的环境的.yml文件。

#首先通过activate target_env要分享的环境target_env，然后输入下面的命令会在当前工作目录下生成一个environment.yml文件，

conda env export > environment.yml

#小伙伴拿到environment.yml文件后，将该文件放在工作目录下，可以通过以下命令从该文件创建环境

conda env create -f environment.yml

```
``yml``是这样的

{% asset_img 2022-05-23-16-19-29.png %}

### 包管理
列举当前活跃环境下的所有包
```bat
conda list
```
列举一个非当前活跃环境下的所有包
```bat
conda list -n your_env_name
```
为指定环境安装某个包
```bat
conda install -n env_name package_name
```

# 搭载``VsCode``使用``junpyter``

安装``VsCode``插件
{% asset_img 2022-05-23-16-19-42.png %}

这个时候就具备使用``Jupyter``的条件了,因为``Python``插件内部也安装了``Jupyter``插件,此时``Ctrl+Shift+P``弹出
{% asset_img 2022-05-23-16-19-49.png %}

新建一个``Jupyter``就可以使用了

{% asset_img 2022-05-23-16-19-55.png %}

如果报错,一般重启一下VSCode就能够使用,喜欢使用主要是因为``Jupyter``可以一行一行的执行,嘻嘻




