---
title: Vue3项目的创建
hide: false
abbrlink: 21d4b84b
date: 2022-02-14 22:17:09
tags:
- 前端
- Vue
categories:
- 前端
- Vue
keywords:
- 前端
- Vue
---

# Vue3项目的创建

==一般来说,创建Vue项目有两种方式==

## 方法一:使用 vue-cli 创建

[Vue文档](https://cli.vuejs.org/zh/guide/creating-a-project.html#vue-create)

<!-- more -->

> 进入一个空的文件目录创建


![1611580424077.png](img/1611580424077.png)

```node
## 安装或者升级
npm install -g @vue/cli

## 保证 vue cli 版本在 4.5.0 以上
vue --version

## 创建项目
vue create <项目名>

## 进入项目 
cd  <项目名>

## 启动项目
npm run serve
```

**然后的步骤**

- ``Please pick a preset`` - 选择 ``Manually select features``
- ``Check the features needed for your project`` - 选择上 ``TypeScript`` ，特别注意点空格是选择，点回车是下一步
- ``Choose a version of Vue.js that you want to start the project with`` - 选择 ``3.x`` (``Preview``)
- ``Use class-style component syntax`` - 直接回车
- ``Use Babel alongside TypeScript`` - 直接回车
- ``Pick a linter / formatter config`` - 直接回车
- ``Use history mode for router?`` - 直接回车
- ``Pick a linter / formatter config`` - 直接回车
- ``Pick additional lint features`` - 直接回车
- ``Where do you prefer placing config for Babel, ESLint, etc.?`` - 直接回车
- ``Save this as a preset for future projects?`` - 直接回车

## 方法二:使用 vite 创建

[文档链接](https://v3.cn.vuejs.org/guide/installation.html)

- ``vite`` 是一个由原生 ESM 驱动的 Web 开发构建工具。在开发环境下基于浏览器原生 ES imports 开发，

- 它做到了**本地快速开发启动**, 在生产环境下基于 ``Rollup`` 打包。
    - 快速的冷启动，不需要等待打包操作；
    - 即时的热模块更新，替换性能和模块数量的解耦让更新飞起；
    - 真正的按需编译，不再等待整个应用编译完成，这是一个巨大的改变。

```node
npm init vite-app <project-name>
cd <project-name>
npm install
npm run dev
```


## 使用Vue-Cli工程各目录介绍


## ``Vue``修改端口号

`package.json`文件下修改 `–port`
```json
"scripts": {
   "serve": "vue-cli-service serve --port 9991",
 }
```
`vue.config.js`文件下添加 (如果没有就在根目录下创建文件)
```js
module.exports = {
  devServer: {
    port: 9991
  }
}
```


