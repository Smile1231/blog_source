---
title: 使用EasyExcel读取excel文件为Java实体类
hide: false
tags:
  - EasyExcel
  - Java
categories: Java
abbrlink: '13370746'
date: 2021-12-15 16:02:49
keywords:
---

[附赠`EasyExcel`的官方文档](https://www.yuque.com/easyexcel/doc/read)

最近用到了需要使用`Excel`的`InputStream`流转化为Java实体类,然后再进行一些业务上的操作,这边稍加学习了之后也做了一些整理:

本次所用到的依赖:

```gradle
implementation 'org.projectlombok:lombok:1.18.20'
implementation group: 'cn.hutool', name: 'hutool-all', version: '5.7.16'
implementation('com.alibaba:easyexcel:2.2.6')
implementation 'com.google.protobuf:protobuf-java:4.0.0-rc-2'
```

## 首先需要建立一个和`Excel`相对应的实体类
```java
@Data
public class IndexOrNameData {
    /**
     * 强制读取第三个 这里不建议 index 和 name 同时用，要么一个对象只用index，要么一个对象只用name去匹配
     *  index 从0开始
     */
    @ExcelProperty(index = 2)
    private Double doubleData;
    /**
     * 用名字去匹配，这里需要注意，如果名字重复，会导致只有一个字段读取到数据
     */
    @ExcelProperty("字符串标题")
    private String string;
    @ExcelProperty("日期标题")
    private Date date;
}
```

<!-- more -->

## 监听器
使用解析功能时需要使用到`easyExcel`提供给我们的一个监听器

{% asset_img 2021-12-15-18-51-15.png %}

所以我这边选择的是继承`AnalysisEventListener`类,是一个通用泛型类

**有个很重要的点`ExcelListener` 不能被`spring`管理，要每次读取`excel`都要`new`,然后里面用到`spring`可以构造方法传进去**
```java
@Slf4j
public class ExcelListener<T> extends AnalysisEventListener<T> {

    //用来获取解析到的数据
    private List<T> dataList = new ArrayList<>();

    @Override
    public void invoke(T data, AnalysisContext context) {
        log.info("解析到一条数据:{}", JSON.toJSONString(data));
        dataList.add(data);
    }

    @Override
    public void doAfterAllAnalysed(AnalysisContext context) {
        log.info("所有数据解析完成！");
    }

    public List<T> getDataList() {
        return dataList;
    }
}
```
## 工具类泛化使用

```java
public class ExcelUtil{

    // 读取excel InputStream流 
    public static <T> List<T> readExcel(InputStream excelInputStream, Class<T> clazz){
        ExcelListener<T> excelListener = new ExcelListener<>();
        //此处的read方法也支持`file`类型,这边使用的是inputStream流
        ExcelReader excelReader = EasyExcel.read(excelInputStream, clazz, excelListener).build();
        if (ObjectUtil.isNull(excelReader)){
            return new ArrayList<T>();
        }
        List<ReadSheet> readSheetList = excelReader.excelExecutor().sheetList();
        for (ReadSheet readSheet : readSheetList) {
            excelReader.read(readSheet);
        }
        excelReader.finish();
        return Convert.toList(clazz,excelListener.getDataList());
    }
}
```
由于第二个参数 `clazz`的原因,只要传入了相应的泛型类,就会返回相应类型的`List`

```java
public static void main(String[] args) {
        File file = new File("D:\\Download\\test.xlsx");
        try {
            InputStream fileInputStream = new FileInputStream(file);
            List<IndexOrNameData> driverBlackListExcels = ExcelUtil.readExcel(fileInputStream, IndexOrNameData.class);
            System.out.println(driverBlackListExcels);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

}
```
{% asset_img 2021-12-15-19-09-34.png %}


## `JavaList`封装为`Excel`返回

上面已经介绍完如果读取上传的`Excel`文件,接下来需要介绍如何将`List`数据输出为`Excel`文件

一样需要建立一个和`Excel`对应的实体类:
```java
@Data
public class TestExcelPojo {
    @ExcelProperty("姓名")
    private String name;
    @ExcelProperty("年龄")
    private String age;
    @ExcelProperty("余额")
    private String money;
    /**
     * 忽略这个字段
     */
    @ExcelIgnore
    private String ignore;
}
```

这边有一个注意点,就是`@ExcelProperty`是把你的`Excel`头换成了对应的值,但是存在于这个实体类中属性都会被解析出来放到输出的`Excel`文件中.

然后使用`EasyExcel`提供的方法来进行数据的写,一下是用例代码:

```java
@SpringBootTest
public class TestEasyExcel {

    @Value("${download.tmpPath}")
    private String tmp;

    @Test
    void Context01(){
        ArrayList<TestExcelPojo> pojoArrayList = new ArrayList<>();
        TestExcelPojo pojo = new TestExcelPojo("测试", "21", "100");
        pojoArrayList.add(pojo);
        pojoArrayList.add(pojo);
        pojoArrayList.add(pojo);
        pojoArrayList.add(pojo);
        pojoArrayList.add(pojo);

        String fileName = tmp + File.separator + IdUtil.simpleUUID() + ".xlsx";
        ExcelWriter excelWriter = null;
        try {
            excelWriter = EasyExcel.write(fileName,TestExcelPojo.class).build();
            WriteSheet writeSheet = EasyExcel.writerSheet("模板").build();
            excelWriter.write(pojoArrayList,writeSheet);
            FileInputStream fileInputStream = new FileInputStream(fileName);
            //转化为二进制流
            ByteString bytes = ByteString.readFrom(fileInputStream);
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            if (excelWriter != null) {
                excelWriter.finish();
            }
        }

    }
}
```
{% asset_img 2021-12-16-15-33-13.png %}
