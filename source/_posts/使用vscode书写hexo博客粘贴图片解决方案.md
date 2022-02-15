---
title: 使用vscode书写hexo博客粘贴图片解决方案
hide: false
abbrlink: 45934af9
date: 2021-11-17 14:22:03
tags:
 - blog
 - hexo
 - next
categories: 
- Hexo
- Tools
keywords: hexo
---

以前都是在`Vscode`中写一些`MarkDown`文档,然后上传到`GitHub`上做好目录供阅读使用:

{% asset_img 2021-11-17-14-35-44.png %}

如今搭建好了``Blog``,图片粘贴也是必不可少的,翻阅大量网站资料,目前本人是采用的如下方式:

<!-- more -->

- 修改`hexo`配置文件: `post_asset_folder: true`,开启之后,生成新的`post`时,会在`source/_posts/`下创建一个同名文件夹
   {% asset_img 2021-11-17-14-41-29.png %}
- 下载插件:`paste image` {% asset_img 2021-11-17-14-47-25.png %}
  这个插件用来在md文档中粘贴图片，默认会在文档的同级目录下新建一个图片文件，并在`md`中插入一行相对路径的图片代码。迎合上述`hexo`的新图片插入方式，可以在`vscode`的`user-settings`里新增两条配置:
  {% asset_img 2021-11-17-14-49-06.png %} 
  {% asset_img 2021-11-17-14-49-20.png %} 
  {% asset_img 2021-11-17-14-49-44.png %} 
  {% asset_img 2021-11-17-14-50-14.png %}
  ```json
  "pasteImage.path": "${currentFileNameWithoutExt}/",
  "pasteImage.insertPattern": "{% asset_img ${imageFileName} %}"
  ```
  这样以来，粘贴的图片就会保存到md文档的同名文件夹下，文档中将插入`hexo asset`语法的代码。然后再复制或者剪切之后的图片,使用快捷键.(`windows`是`ctrl+Alt+V`,`Mac`是`Command+option+V`),但是`hexo clean -> hexo g -> hexo s`之后图片就可以正常显示了
  {% asset_img 2021-11-17-15-16-19.png %}

- (以下的步骤需要修改到`markdown`源码,慎重考虑),由于重新新建一个文件夹的特殊性,所以需要略微修改
  - 下载预览插件: `Markdown Preview Enhanced`
    {% asset_img 2021-11-17-15-01-16.png %}
  - 现在就要利用这个功能来解决一个问题：`vscode`内无法预览代码的图片。`ctrl+shift+P`输入`Markdown Preview Enhanced: Extend Parser`调出插件的`parse.js`文件，修改其中的`onWillParseMarkdown`方法：
   ```js
   module.exports = {
    onWillParseMarkdown: function(markdown) {
      return new Promise((resolve, reject)=> {
        //markdown参数打印出来是整个文件的内容
        var a = markdown.split("\n");//通过下面第一张图片内容通过换行符进行切割
        var b = a[1].substring(6); //获取到title行字符,然后再去除空格即可获得图片的路径
        markdown = markdown.replace(
          //以下为代码，注释是因为markdown语法会渲染出错，但是是正确代码
        //  /\{%\s*asset_img\s*(.*)\s*%\}/g,
         // (whole, content) => ('![]('+b.trim()+'/'+content+')')
        )
        return resolve(markdown)
      })
    },
    ...
   }
   ```
   {% asset_img 2021-11-17-18-00-53.png %}
   尝试过后,图片的预览功能就能实现啦.

   {% asset_img 2021-11-17-18-03-07.png %}


参考链接(图片重写预览功能有错误,本文已经修正):https://linbei.top/vscode%E7%BC%96%E5%86%99md/