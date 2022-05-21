---
title: Springboot+Vue二进制文件传输
hide: false
tags:
  - SpringBoot
  - 文件上传
keywords:
  - SpringBoot
  - 文件上传
abbrlink: a1926332
date: 2022-05-21 21:42:10
categories:
---

最近用到了`springboot`项目返回二进制流，话不多说，代码贴上:

```java
@PostMapping(value = "/file/{fileName}")
public ResponseEntity<FileSystemResource> getFile(@PathVariable("fileName") String fileName) throws FileNotFoundException {
	File file = new File(filePath, fileName);
	if (file.exists()) {
		return export(file);
	}
	System.out.println(file);
	return null;
}
 
public ResponseEntity<FileSystemResource> export(File file) {
	if (file == null) {
		return null;
	}
	HttpHeaders headers = new HttpHeaders();
	headers.add("Cache-Control", "no-cache, no-store, must-revalidate");
	headers.add("Content-Disposition", "attachment; filename=" + file.getName());
	headers.add("Pragma", "no-cache");
	headers.add("Expires", "0");
	headers.add("Last-Modified", new Date().toString());
	headers.add("ETag", String.valueOf(System.currentTimeMillis()));
	return ResponseEntity.ok()
                        .headers(headers)
                        .contentLength(file.length())
                        .contentType(MediaType.parseMediaType("application/octet-stream"))
                        .body(new FileSystemResource(file));
}
```
<!-- more -->

前端`Vue`代码：

```java
downloadXLSXFile() {
	var that = this;
	that.axios
	.post(
		"/download/XLSXExampleFile",
		{ fileId: 123 }, //入参
		{ responseType: "blob" } // 设置responseType对象格式为 blob:
	)
	.then((res) => {
		let blob = new Blob([res.data], {
		type: "application/octet-stream",
		}); // 获取请求返回的response对象中的blob 设置文件类型

		let url = window.URL.createObjectURL(blob); // 创建一个临时的url指向blob对象
		let a = document.createElement("a");
		a.href = url;
		a.download = "text.xslx"; //下载的文件名
		a.click();
		window.URL.revokeObjectURL(url); //释放blob对象
	});
}
```

> 同时贴一个`Springboot`接受前端`Vue``对象参数

```java
@Slf4j
@RequestMapping("/business")
@RestController
public class SubmitController {
    @Autowired
    private SubmitService submitService;

    @PostMapping("/submit")
    public ResultVO submitAction(@RequestBody UploadFileSubmitEntity uploadFileSubmitEntity){
        log.info("start submitAction ...");
        log.info(uploadFileSubmitEntity.toString());
        return submitService.submitAction(uploadFileSubmitEntity);
    }
}

@Data
public class UploadFileSubmitEntity {
    //gz 文件列表
    @JsonProperty("GZFileList")
    private ArrayList<UploadRes> GZFileList;
    //xlsx 文件列表
    @JsonProperty("XLSXFileList")
    private ArrayList<UploadRes> XLSXFileList;
}
```
前端:

```js
var that = this;
var param = {
	"GZFileList": this.GZFileList,
	"XLSXFileList": this.XLSXFileList,
};
that.axios({
	method: "post",
	url: "/business/submit",
	data: JSON.stringify(param),
	headers: {
		"Content-Type": "application/json;charset=UTF-8",
	},
	})
	.then((res) => {
	if(res.data.code == 200){
		that.$message.success("submit successfully! , Plz wait for some time .");
	}
	});
```











