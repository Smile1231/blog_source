---
title: The learning of Jenkins Grammer
hide: false
tags:
  - Jenkins
  - Groovy
categories:
  - Jenkins
keywords:
  - Jenkins
  - Groovy
abbrlink: 273d98ce
date: 2022-07-10 13:44:11
---


Recently , i use jenkinsFile to realize some function 


## 处理`JSON`


## 压缩方法

可能是自带的方法
```groovy
zip zipFile: '<zipFileName>', archive: true, glob: '<file_path>'

// example： zip zipFile: 'upload.zip', archive: true, glob: '/binary/'
```


## `JSON`操作

> 读取：从文件中读取  `JSON` 字符串，并直接解析为对象
```groovy
// 从文件中读取
def dataObject = readJSON file: 'message2.json'
echo "color: ${dataObject.attachments[0].color}"

//从文本中读取
def dataObject = readJSON text: 'message2.json'

```
> 写入文件
```groovy
//保存：将对象直接写入文件，无需先转化为 JSON 字符串
// Building json from code and write it to file
writeJSON(file: 'message1.json', json: dataObject)
```


## groovy获取shell执行结果和执行状态码
> 获取执行结果
```groovy
result = sh(script: "shell command", returnStdout: true)
```
> 获取执行状态码（0或者非0）
```groovy
excuteCode = sh(script: "shell command", returnStatus: true)
```
## `Jenkins`声明式`Pipeline`中单引号和双引号的区别

[原文地址](https://blog.csdn.net/qq_34719392/article/details/121472894)

1. 如果使用三个单引号，那么其中的字符，除了`'\'`会被解析为转义字符外，其他都会被原封不动地传递给`P`owershell`，不作任何解析
2. 如果使用三个双引号，则绝大部分字符也会被原封不动地传递给`Powershel`l，但如下三个字符除外：

    ① `'$'`（美元字符）`：`用于引用`Jenkinsfile`中的环境变量。

    ② `'\'`（反斜杠字符）`：`用于转义。

    ③ `' " '`（双引号字符）：本身无特殊含义，但是三个双引号之间不允许出现非转义的双引号字符，否则将导致语法错误。

如果确实需要使用上述三个字符本身，而不是使用其特殊含义，则必须在前面加上`'\'`字符进行转义，即：`'\$'`、`'\\'`、`'\"'`。

> 总结`：`

三单引号的优点是，语法简洁，不存在过多转义；缺点是，无法引用`Jenkins`中的环境变量。而三双引号的优缺点与此正好相反。

个人对于使用三双引号的建议是：仅在必须声明和引用`Powershell`变量（而非`Jenkins`环境变量）时，才使用三单引号或三双引号。其他时候，每一条命令都应拆分，并以`powershell`开头。这样做的好处是便于调试（尤其是使用`Blue Ocean`调试时）。在这一前提下，如果需要在三引号中引用`Jenkins`环境变量，则必须使用三双引号；否则，使用三单引号表达更为简洁。

## `jenkins pipeline`中获取`shell`命令的标准输出或者状态

```groovy
//获取标准输出
//第一种
result = sh returnStdout: true ,script: "<shell command>"
result = result.trim()
//第二种
result = sh(script: "<shell command>", returnStdout: true).trim()
//第三种
sh "<shell command> > commandResult"
result = readFile('commandResult').trim()

//获取执行状态
//第一种
result = sh returnStatus: true ,script: "<shell command>"
result = result.trim()
//第二种
result = sh(script: "<shell command>", returnStatus: true).trim()
//第三种
sh '<shell command>; echo $? > status'
def r = readFile('status').trim()

//无需返回值，仅执行shell命令
//最简单的方式
sh '<shell command>'
```
例如：
> 工作中需要获取`shell `命令的执行状态，返回0或者非0
`groovy`语句写法为：
```groovy
def exitValue = sh(script: "grep -i 'xxx' /etc/myfolder", returnStatus: true)
echo "return exitValue :${exitValue}"
if(exitValue != 0){
    执行操作
}
```
如果`grep`命令执行没有报错，正常情况下`exitValue`为`0`，报错则为非`0`

需要注意的是当命令中存在重定向的时候，会出现返回状态异常，因为我们要返回状态，删除重定向（`&>/dev/null`）即可，比如：
```groovy
def exitValue = sh(script: "grep -i 'xxx' /etc/myfolder &>/dev/null", returnStatus: true)
xxx不存在，正常逻辑是返回非0，但是实际中返回的是0 。可以理解为先执行命令然后赋值操作，类似下面的动作：（个人理解）
sh "ls -l > commandResult"
result = readFile('commandResult').trim()
```

`groovy`中存在另外一种解析`shell`脚本的方法，在`jenkins pipeline`中会使用会报异常,`jenkins`相关资料中也没有看到此种用法，应该是不支持
```
groovy.lang.MissingPropertyException: No such property: rhel for class: groovy.lang.Binding
```
写法为：
```groovy
def command = "git log"
def proc = command.execute()
proc.waitFor()
def status = proc.exitValue()
```


