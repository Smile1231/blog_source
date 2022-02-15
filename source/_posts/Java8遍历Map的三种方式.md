---
title: Java8遍历Map的三种方式
hide: false
tags:
  - map
  - Stream流
categories: Java
keywords:
  - map
  - Stream流
  - Tools
abbrlink: fc16798c
date: 2021-12-16 16:47:03
---

常见的`Java8`遍历`Map`的三种方式
- `for`循环
- `stream`流的方式处理
- `forEach`方法遍历

[转载](https://juejin.cn/post/6844903927096295432)

`Show me the code first!`以下是代码，解释一下逻辑，原来的`cookies`数据结构为`Map<String, List<HttpCookie>>`,其中`HttpCookie`为`cookie`键值对，由于业务需要，我们需要将其转换成`Map<String, String>`才更方便处理，于是乎就有了以下代码。（我这里直接用了`foreach`循环，也可以用`fori`循环，例如`for(int i = 0; i< xx; i++)`）

<!-- more -->
## `for`循环遍历
```java
// 从request中获取原始的cookie
MultiValueMap<String, HttpCookie> cookies = request.getCookies(); 
Map<String, String> cookieMap = new HashMap<>(); // 新建一个map，将cookie转入该map中
for (Map.Entry<String, List<HttpCookie>> itemList : cookies.entrySet()) { // 遍历原始的MultiValueMap
	for (HttpCookie item :itemList.getValue()) { // 遍历每个item中的List<HttpCookie>，其中的HttpCookie是我们需要的内容
		cookieMap.put(item.getName(), item.getValue()); // 存入内容
	}
}
```

## `stream`流的方式处理
在`Java8`中，我们可以使用流，将`Collections`或者数组转化成`Stream`，并用链式的调用更加逻辑更加清晰。
```java
MultiValueMap<String, HttpCookie> cookies = request.getCookies();
Map<String, String> cookieMap = new HashMap<>();

cookies.entrySet() // 获取entrySet
	.stream() // 将其转化成流
	.map(Map.Entry<String, List<HttpCookie>>::getValue) // MultiValueMap<String, HttpCookie> -> List<HttpCookie>
	.flatMap(List<HttpCookie>::stream) // List<HttpCookie> -> HttpCookie
	.forEach(cookie -> cookieMap.put(cookie.getName(), cookie.getValue())); // 遍历，存入内容
```
## `Collection`具有的`forEach`方法遍历

### 继续用`Stream`处理
我们可以看到通过流的方法处理`cookie`的方法，接下来，我们接着用相同的方法来处理请求参数，请求参数原本的数据格式依然为`MultiValueMap<String, String>`，可以看做是`Map<String, List<String>>`，其中请求参数名（`key`）对应的值（`value`）可能为多行，我们需要将其处理成一行。
```java
MultiValueMap<String, String> params = request.getQueryParams();
Map<String, String> paramMap = new HashMap<>();

params.entrySet()
	.forEach(entry ->
		paramMap.put(
			entry.getKey(), // 将参数名写入Key
			entry.getValue().stream().collect(Collectors.joining())) // 参数值多行合并成一行写入value
	);
```
大家可以看到，在处理参数值（`value`）的时候，值为`List<String>`数据结构，以上代码通过`entry.getValue().stream().collect(Collectors.joining()))`将其`List`先转化为`Stream`，再用流的`collection`方法，将其合并。这个`Collectors`还具有将`toSet/toList/groupingBy`等功能，大家可以自行研究，这里就是使用的是`joining`合并方法。

### 使用`Collection`的`forEach`方法遍历`Map`

修改后的代码如下：
```java
params.forEach((key, value) -> paramMap.put(key, String.join(" ", value)));
```





