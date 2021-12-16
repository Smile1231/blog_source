---
title: 将Java数据输出为本地txt
hide: false
tags:
  - Java
  - 流
categories: Java
abbrlink: 1c3390ab
date: 2021-12-16 17:57:55
keywords:
---

转载[https://www.cnblogs.com/vickylinj/p/15490194.html](https://www.cnblogs.com/vickylinj/p/15490194.html)

 将`List`写入文件：
<!-- more -->
```java
public void writeList2File(List<Long> lines, String filePath) {
    File file = new File(filePath);
    // 判断文件是否存在
    if (!file.exists()) {
        file.createNewFile();
    }
    // 遍历写入
    BufferedWriter bw = new BufferedWriter(new FileWriter(file));
    for (long lineL : lines) {
        bw.write(long2DateString(lineL) + "\r\n");
    }
    bw.flush();
    bw.close();
}
```

将文件读为`List`：

```java
public ArrayList<String> readFile2List() {
    // 获取到文件流
    File inputFile = new File("D:\\dir\\file.txt");
    InputStreamReader inputStreamReader = new InputStreamReader(new FileInputStream(inputFile));
    BufferedReader br = new BufferedReader(inputStreamReader);

    // 将文件读到 List中
    String line = null;
    ArrayList<String> lines = Lists.newArrayList();
    while ((line = br.readLine()) != null) {
        lines.add(line);
    }
    return lines;
}
```



