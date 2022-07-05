---
title: Springboot工程项目.gitignore配置
hide: false
tags:
  - Java
  - SpringBoot
abbrlink: ba003691
date: 2022-06-30 08:57:45
categories:
keywords:
---

{% asset_img 2022-06-30-08-58-34.png %}

<!-- more -->

`SpringBoot`根目录下创建`.gitignore`

```bash
../HELP.md
target/
!.mvn/wrapper/maven-wrapper.jar
!**/src/main/**
!**/src/test/**

### STS ###
.apt_generated
.classpath
.factorypath
.project
.settings
.springBeans
.sts4-cache
.log

### IntelliJ IDEA ###
.idea
*.iws
*.iml
*.ipr
.mvn
mvnw*
HELP.md

### NetBeans ###
/nbproject/private/
/nbbuild/
/dist/
/nbdist/
/.nb-gradle/
build/

### VS Code ###
.vscode/

### generated files ###
bin/
gen/

### MAC ###
.DS_Store

### Other ###
logs/
log
temp/
```


