---
title: Java通过URL下载资源
hide: false
tags: Java
categories: Java
keywords: Java
abbrlink: a54ed4b0
date: 2022-08-11 12:18:32
---

关于如何通过下载`URL`下载网络资源，最近做了一些整理

[参考文章](https://www.baeldung.com/java-download-file)


差不多以下的几个都是可以`work`的

```java
public class DownloadByUrl {

    private static final String DOWNLOAD_URL = "https://archive.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz";
    private static final String FILE_NAME = "download_file/maven-3.5.4-bin.tar.gz";


    @Test
    void downloadByJavaIO() throws Exception {
        try (BufferedInputStream in = new BufferedInputStream(new URL(DOWNLOAD_URL).openStream())){
            FileOutputStream fileOutputStream = new FileOutputStream(FILE_NAME);
            byte[] dataBuffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = in.read(dataBuffer,0,1024)) != -1){
                fileOutputStream.write(dataBuffer,0,bytesRead);
            }
        }

    }

    @Test
    void downloadByJavaIOAndCopy() throws Exception{
        InputStream in = new URL(DOWNLOAD_URL).openStream();
        Files.copy(in, Paths.get(FILE_NAME), StandardCopyOption.REPLACE_EXISTING);
    }

    @Test
    void downloadByNIO(){
        try (FileOutputStream fileOutputStream = new FileOutputStream(FILE_NAME)){
            ReadableByteChannel readableByteChannel = Channels.newChannel(new URL(DOWNLOAD_URL).openStream());
            // get a file channel
            ;
//            FileChannel fileChannel = fileOutputStream.getChannel();
            fileOutputStream.getChannel()
                    .transferFrom(readableByteChannel,0,Long.MAX_VALUE);

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    @Test
    void downloadByCommonsIO() throws Exception{
        FileUtils.copyURLToFile(
                new URL(DOWNLOAD_URL)
                ,new File(FILE_NAME)
                ,1000
                ,2000
        );

    }
}
```

