---
title: 在Javadoc注释中引用方法
hide: false
tags: Java
categories: Java
keywords: Java
abbrlink: d6d1be75
date: 2022-05-21 22:00:19
---

最近用到如何在注释中`link`到另一个类

1. `@link`标签
`Javadoc` 提供了`@link`内联标记来引用Java 类中的成员。我们可以认为`@link`标签类似于 `HTML` 中的锚标签，用于通过超链接将一个页面链接到另一个页面。

让我们看看使用`@link`标记引用 `Javadoc` 注释中的方法的语法：
```java
{@link path_to_member label}
```

与锚标签类似，`path_to_member`是目的地，标签是显示文本。

标签是可选的，但`path_to_member`是引用方法所必需的。但是，始终使用标签名称来避免复杂的参考链接是一种很好的做法。`path_to_member`的语法 根据我们引用的方法是否驻留在同一个类中而有所不同。

需要注意的是，大括号`{`和`@link`之间不能有空格。如果它们之间有空格，`Javadoc `工具将无法正确生成引用。但是， `path_to_member、label`和右大括号之间没有空间限制。

<!-- more -->

2. 引用同一个类中的方法
引用方法的最简单方法是在同一个类中：
```java
{@link #methodName() LabelName}
```
假设我们正在记录一个方法，并且我们想从同一个类中引用另一个方法：
```java
/**
 * Also, check the {@link #move() Move} method for more movement details.
 */
public void walk() {
}

public void move() {
}
```
在这种情况下，`walk()`方法引用同一类中的`move()`实例方法。

如果被引用的方法有参数，当我们想要引用一个重载或参数化的方法时，我们必须相应地指定其参数的类型。

考虑以下引用重载方法的示例：
```java
/**
 * Check this {@link #move(String) Move} method for direction-oriented movement.
 */
public void move() {

}

public void move(String direction) {

}
```
`move()`方法是指一种采用一个String参数的重载方法。

3. 引用另一个类中的方法
要引用另一个类中的方法，我们将使用类名，后跟标签，然后是方法名：
```java
{@link ClassName#methodName() LabelName}
```
语法类似于引用同一类中的方法，除了在`#`符号之前提到类名。

现在，让我们考虑在另一个类中引用方法的示例：
```java
/**
 * Additionally, check this {@link Animal#run(String) Run} method for direction based run.
 */
public void run() {

}
```
引用的方法在同一个包中的`Animal`类中：
```java
public void run(String direction) {

}
```
如果我们想引用另一个包中的方法，我们有两个选择。一种方法是直接指定包以及类名：
```java
/**
 * Also consider checking {@link com.baeldung.sealed.classes.Vehicle#Vehicle() Vehicle} 
 * constructor to initialize vehicle object.
 */
public void goToWork() {

}
```
在这种情况下，已经使用完整的包名称提到了`Vehicle`类，以引用`Vehicle()`方法。

此外，我们可以导入包并单独提及类名：
```java
import com.baeldung.sealed.records.Car;

/**
 * Have a look at {@link Car#getNumberOfSeats() SeatsAvailability} 
 * method for checking the available seats needed for driving.
 */
public void drive() {

}
```
在这里，驻留在另一个包中的`Car`类已被导入。所以，`@link`只需要包含类名和方法。

我们可以选择两种方式中的任何一种来引用不同包中的方法。如果是单次使用包，那么我们可以使用第一种方式，否则，如果有多个依赖项，我们应该选择第二种方式。

4. `@linkplain`标签
我们已经在注释中看到了用于引用方法的`@link Javadoc` 标记。`Javadoc` 提供了另一个名为`@linkplain` 的标记，用于在注释中引用方法，类似于`@link`标记。主要区别在于，在生成文档时，`@link`以等宽格式文本生成标签值，而`@linkplain`以标准格式（如纯文本）生成它。



[ 原文章地址 ](https://www.zditect.com/main-advanced/java/java-method-in-javadoc.html)