---
title: SpringBoot如何优雅的发邮件
hide: false
tags:
  - SrpingBoot
abbrlink: ac1ae082
date: 2022-07-05 23:45:58
categories:
keywords:
---

这里演示使用`163`邮箱发邮件

## 注册`163`，并打开配置

记得保存授权吗

{% asset_img 2022-07-06-21-58-05.png %}

<!-- more -->

## 增加`maven`以来

```xml
<!-- send email -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-mail</artifactId>
</dependency>
```

## `yaml`文件配置

```yaml
spring:
  mail:
    host: smtp.163.com
    username: ******** #登陆账号
    password: ******** #登陆密码（或授权码），开启上面配置时会有
    properties:
      from: JinMaoToRich@163.com #邮件发信人（即真实邮箱）
```

## `Java`代码

实体类代码
```java
@Data
public class SendEmailRecord implements Serializable {
/**
    * 主键
    */
private Integer id;
/**
    * 邮件发送人
    */
private String from;
/**
    * 邮件接受人
    */
private String to;
/**
    * 邮件主题
    */
private String subject;
/**
    * 邮件内容
    */
private String text;
/**
    * 抄送
    */
private String cc;
/**
    * 密送
    */
private String bcc;
/**
    * 0 - ok , 1 - fail
    */
private Byte status;
/**
    * 报错信息
    */
private String error;
/**
    * 发送时间
    */
private Date sendDate;
/**
    * 计算文件夹路径
    */
private String computationDirectory;
/**
    * 邮件附件
    */
@JsonIgnore
private List<File> fileList;
}
```


发送邮件代码
```java
@Slf4j
@Component
public class SendMailService {
    @Autowired
    private JavaMailSenderImpl mailSender;//注入邮件工具类
    @Autowired
    private SendEmailRecordDao sendEmailRecordDao;
    @Autowired
    private ShellProperties shellProperties;

public void SendMailWithAttach(SendEmailRecord sendEmailInfo){
    try {
        log.info("start to send email to {}",sendEmailInfo.getTo());
        MimeMessageHelper messageHelper = new MimeMessageHelper(mailSender.createMimeMessage(), true);//true表示支持复杂类型
        sendEmailInfo.setFrom(getMailSendFrom());//邮件发信人从配置项读取
        messageHelper.setFrom(sendEmailInfo.getFrom());//邮件发信人
        messageHelper.setTo(sendEmailInfo.getTo().split(","));//邮件收信人
        messageHelper.setSubject(sendEmailInfo.getSubject());//邮件主题
        messageHelper.setText(sendEmailInfo.getText());//邮件内容
        if (StrUtil.isNotBlank(sendEmailInfo.getCc())) {//抄送
            messageHelper.setCc(sendEmailInfo.getCc().split(","));
        }
        if (StrUtil.isNotBlank(sendEmailInfo.getBcc())) {//密送
            messageHelper.setCc(sendEmailInfo.getBcc().split(","));
        }
        if (CollUtil.isNotEmpty(sendEmailInfo.getFileList())) {//添加邮件附件
            for (File file : sendEmailInfo.getFileList()) {
                messageHelper.addAttachment(file.getName(),file);
            }
        }
        mailSender.send(messageHelper.getMimeMessage());//正式发送邮件
        sendEmailInfo.setStatus(SendMailStatusEnum.OK.getCode());
        log.info("Send Email Success ：{}->{}", sendEmailInfo.getFrom(), sendEmailInfo.getTo());
    } catch (Exception e) {
        log.error("send Email failed , error is {}",e.getMessage());
        sendEmailInfo.setStatus(SendMailStatusEnum.FAILED.getCode());
        sendEmailInfo.setError(e.getMessage());
    }finally {
        saveMail(sendEmailInfo);
    }
}

//保存邮件
private void saveMail(SendEmailRecord emailInfo) {
    log.info("start save send email record to database.");
    if (Objects.equals(emailInfo.getTo(),shellProperties.getAlarmEmail())){
        log.info("this is alarm email , email info is {}",emailInfo);
        emailInfo.setStatus(SendMailStatusEnum.FAILED.getCode());
    }
    sendEmailRecordDao.insertSelective(emailInfo);
}

//获取邮件发信人
public String getMailSendFrom() {
    return mailSender.getJavaMailProperties().getProperty("from");
}
}
```




