---
title: Hexo-Next主题如何文章置顶
hide: false
abbrlink: 575a6046
date: 2021-11-17 11:06:14
tags:
 - blog
 - hexo
 - next
categories: Hexo
keywords:
---

# 文章置顶

`Hexo` 本身并没有内置文章置顶功能，因此需要自行安装。不过 `Hexo` 本身有一个对文章排序的组件，也就是在站点配置文件内的 `index_generator` 选项，置顶功能其实就是每次排序的时候，把其中的置顶文章排在最前，本质上是一个排序组件，`Hexo` 默认的是 `hexo-generator-index`，所以先卸载再重新安装一个可以置顶的排序组件：

<!-- more -->
```node
# 先卸载
npm uninstall --save hexo-generator-index

# 再安装
npm install --save hexo-generator-index-pin-top
```
从插件名字上就能看得出来支持置顶了。该插件的 `GitHub` 地址：[hexo-generator-index-pin-top](https://github.com/netcan/hexo-generator-index-pin-top)。插件安装完之后，只需要在文章头部信息栏内设置 `top` 属性即可：

```markdown
---
title: 写在最前面
hide: false
top: true
---
```
这样这篇文章就具有置顶效果了。不过，仅仅只是这么做，文章虽然确实置顶了，但是从文章列表上来看，和普通的文章没什么不同。如果不特意去对比文章发布时间，可能会以为只是最新的文章而已。例如一些说明、通知之类的，为了能有个比较突出的标志，可以在 `next/layout/_macro/post.swig` 文件中找到以下位置并添加代码：
```html
{% if post.top %}
    <i class="fa fa-thumb-tack" style="color: #EB6D39"></i>
    <font color=#FFFF00	>置顶</font>
    <span class="post-meta-divider">|</span>
{% endif %}
```
{% asset_img 2021-11-17-13-47-07.png %}

效果如下:
{% asset_img 2021-11-17-13-54-56.png %}

## 关于在`Hexo`中的小图标

使用`Hexo`搭建的`Blog`中,都是从专门的图标库中获取:

- [国外地址](https://fontawesome.com/icons?d=gallery)
- [国内地址](https://fontawesome.dashgame.com/)

例如在主题的配置文件`_config.yml`中

{% asset_img 2021-11-17-14-01-18.png %}

都是使用的图标库中的图标


