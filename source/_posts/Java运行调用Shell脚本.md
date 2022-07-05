---
title: Java运行调用Shell脚本
hide: false
abbrlink: 8da68a98
date: 2022-06-29 22:02:56
tags:
- Springboot
- Java
categories:
keywords:
---


关于在`java`中如何去调用`shell`脚本，最近忙活了老半天

在`java`中有一个`ProcessBuilder`类,能够调用到`sh`命令，话不多说，贴上代码

<!-- more -->

```java
 public void zipFileAction(String computationDir,String email){
    log.info("###### start zip file , computation is {} ###### ", computationDir);
    // initShell
    Process process = null;
    try {

        ProcessBuilder pb = new ProcessBuilder();
        //这里指的shell文件所在的目录
        pb.directory(new File(DirectoryUtil.getFileLocalAbsolutePathWithFileUrl("shell/action/")));
        //权限
        pb.command("chmod 777 " + shellProperties.getZipShellName());
        //此处的 ./ 不是指当前文件夹 ， 而是指运行的意思
        pb.command("./"+shellProperties.getZipShellName() ,computationDir,shellProperties.getCompressedFileName());
        // 将错误输出流转移到标准输出流中,但使用Runtime不可以
        pb.redirectErrorStream(true);
        process = pb.start();
        //将shell日志写入到文件中
        writeToLocal(DirectoryUtil.getFileLocalAbsolutePathWithFileUrl(computationDir) + "/zipLog.txt",process.getInputStream());
//            String dataMsg = reader(process.getInputStream());
//            log.info("###### shell zip script data message is {} ###### ",dataMsg);
    } catch (IOException e) {
        log.error("###### run shell zip script is error , message is {}######", e.getMessage());
        return;
    }
    int runningStatus = 0;
    try {
        runningStatus = process.waitFor();
    } catch (InterruptedException e) {
        log.error("###### run shell zip script occurs error, error is {} ######", e.getMessage());
        return;
    }
    if(runningStatus != 0) {
        log.error("###### run shell zip script failed.###### ");
    }else {
        log.info("###### run shell zip script success. ######");
    }
}
/**
    * 数据读取操作
    *
    * @param input 输入流
    */
public String reader(InputStream input) {
    StringBuilder outDat = new StringBuilder();
    try (InputStreamReader inputReader = new InputStreamReader(input, StandardCharsets.UTF_8);
            BufferedReader bufferedReader = new BufferedReader(inputReader)) {
        String line;
        while ((line = bufferedReader.readLine()) != null) {
            outDat.append(line);
            outDat.append("\n");
        }
    } catch (IOException e) {
        log.error("exception is {}", e.getMessage());
    }
    return outDat.toString();
}

/**
    * 将InputStream写入本地文件
    * @param destination 写入本地目录
    * @param input	输入流
    * @throws IOException
    */
private void writeToLocal(String destination, InputStream input)
        throws IOException {
    int index;
    byte[] bytes = new byte[1024];
    FileOutputStream downloadFile = new FileOutputStream(destination);
    while ((index = input.read(bytes)) != -1) {
        downloadFile.write(bytes, 0, index);
        downloadFile.flush();
    }
    downloadFile.close();
    input.close();
}
```


