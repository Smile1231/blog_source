---
title: 关于sql执行计划
categories: 数据库
keywords: 'sql,执行计划'
abbrlink: 60f024c8
date: 2021-11-08 16:54:09
tags: 
 - 数据库
 - 执行计划
--- 

最近受到客服的一个反馈:某个功能长时间无反馈,响应时间达到了`20s`以上,通过调用日志发现,某条`sql`查询竟然花费了`12s`的时间,而且查询了两次,于是准备通过执行计划对此进行找方向调优.

# 什么是执行计划

## 1. `MySQL`逻辑结构先知
<!-- more -->

关于`MySQL`的逻辑结构，将其理解为四层，就像项目分层一样，每一层处理不同的业务逻辑，先看图后说话：

{% asset_img 2021-11-17-15-24-30.png %}

上图概述：

- 客户端：这里指连接`MySQL`各种形式，如`.Net`中使用的`ADO`连接、`Java`使用`JDBC`连接等；`MySQL`是客户端和服务器模式，前提先建立连接，才能传输数据，处理相关逻辑；

- 业务逻辑：在`MySQL`内部有很多模块组成，分别处理相关业务逻辑；

- 连接管理：负责连接认证、连接数判断、连接池处理等业务逻辑处理；

- 查询缓存：当一个`SQL`进来时，如果开启查询缓存功能，`MySQL`会优先去查询缓存中检查是否有数据匹配，如果匹配上，就不会再去解析对应的`SQL`啦，但如果语句中有用户自定义函数、存储函数、用户变量、临时表、`mysql`库中的系统表时，都不会走缓存； 对于查询缓存来说，在`MySQL8.0`已经去除，官方回应的是在一定场景上，查询缓存会导致性能上的瓶颈。

- 解析器：对于一个`SQL`语句，`MySql`根据语法规则需要对其进行解析，并生成一个内部能识别的解析树；

- 优化器：负责对解析器得到的解析树进行优化，`MySQL`会根据内部算法找到一个`MySQL`认为最优的执行计划，后续就按照这个执行计划执行。所以后续我们分析的就是`MySQL`针对`SQL`语句选择出来的最优执行计划，结合业务，根据规则对`SQL`进行优化，从而让`SQL`语句在`MySQL`内部达到真正的最优。

- 执行器：得到执行计划之后，就会找到对应的存储引擎，根据执行计划给出的指令依次执行。

- 存储引擎：数据的存储和提取最后是靠存储引擎；`MySQL`内部实现可插拔式的存储引擎机制，不同的存储引擎执行不同的逻辑；

- 物理文件：数据存储的最终位置，即磁盘上；协同存储引擎对数据进行读写操作。

关于`MySql`的逻辑结构，以上只是简单描述，业务逻辑层的功能模块远不止上面提到的，小伙伴有兴趣可以专门研究一下，这里的目的就是为了体现`SQL`语句到服务器上时经过的几个关键步骤，方便后续优化的理解。

## 2.`SQL`语句的中关键字执行顺序须知

在编写一条查询语句时，习惯性的从头到尾开始敲出来，应该都是从`select` 开始吧，但似乎没太注意它们真正的执行顺序；既然要优化，肯定需要得知道一条`SQL`语句大概的执行流程，结合执行计划，目的就更加清晰啦；上一张一看就明白的图：

{% asset_img 2021-11-22-15-55-16.png %}

关键字简述：

- `FROM`：确定数据来源，即指定表；
- `JOIN...ON`：确定关联表和关联条件；
- `WHERE`：指定过滤条件，过滤出满足条件的数据；
- `GROUP BY`：按指定的字段对过滤后的数据进行分组；
- `HAVING`：对分组之后的数据指定过滤条件；
- `SELECT`：查找想要的字段数据；
- `DISTINCT`：针对查找出来的数据进行去重；
- `ORDER BY`：对去重后的数据指定字段进行排序；
- `LIMIT`：对去重后的数据限制获取到的条数，即分页；
好啦，大概了解`MySQL`的逻辑结构和`SQL`查询关键字执行顺序之后，接下来就可以好好说说执行计划啦。

## 3. 好好说说执行计划

通过上面的逻辑结构，当一个`SQL`发送到`MySQL`执行时，需要经过内部优化器进行优化，而使用`explain`关键字可以模拟优化器执行`SQL`查询语句，从而知道`MySQL`是如何处理`SQL`的，即`SQL`的执行计划；根据`explain`提供的执行计划信息分析`SQL`语句，然后进行相关优化操作。接下来的示例演示用到五张表：`USER(用户表)、MENU(菜单表)、ROLE(角色表)、USER_ROLE(用户角色关系表)、ROLE_MENU(角色菜单关系表)、ADDR(用户地址表，这里认为和用户一一对应)、FRIEND(朋友表，一对多关系)`，它们的关系这里就不详细说了吧，小伙伴肯定都明白，这是管控菜单权限的五张基础表和两个基础信息表；

表DDL
```sql
/*
SQLyog Ultimate - MySQL GUI v8.2 
MySQL - 5.5.27 : Database - sql_optimization
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`sql_optimization` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;

USE `sql_optimization`;

/*Table structure for table `addr` */

DROP TABLE IF EXISTS `addr`;

CREATE TABLE `addr` (
  `ID` int(11) NOT NULL,
  `ADDR` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `addr` */

/*Table structure for table `friend` */

DROP TABLE IF EXISTS `friend`;

CREATE TABLE `friend` (
  `USER_ID` int(11) DEFAULT NULL,
  `FRIEND_ID` int(11) DEFAULT NULL,
  KEY `idx_user_id` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `friend` */

/*Table structure for table `menu` */

DROP TABLE IF EXISTS `menu`;

CREATE TABLE `menu` (
  `ID` int(11) NOT NULL,
  `MENU_NAME` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `MENU_URL` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `menu` */

insert  into `menu`(`ID`,`MENU_NAME`,`MENU_URL`) values (1,'用户新增','api/User/Add'),(2,'用户删除','api/User/Delete'),(3,'用户修改','api/User/Update'),(4,'用户查询','api/User/Query'),(5,'角色新增','api/Role/Add'),(6,'角色修改','api/Role/Update'),(7,'角色删除','api/Role/Delete'),(8,'角色查询','api/Role/Query');

/*Table structure for table `role` */

DROP TABLE IF EXISTS `role`;

CREATE TABLE `role` (
  `ID` int(11) NOT NULL,
  `ROLE_NAME` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `role` */

insert  into `role`(`ID`,`ROLE_NAME`) values (1,'admin'),(2,'test'),(3,'custmor'),(4,'role1'),(5,'role2');

/*Table structure for table `role_menu` */

DROP TABLE IF EXISTS `role_menu`;

CREATE TABLE `role_menu` (
  `ID` int(11) NOT NULL,
  `ROLE_ID` int(11) DEFAULT NULL,
  `MENU_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `role_menu` */

insert  into `role_menu`(`ID`,`ROLE_ID`,`MENU_ID`) values (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),(7,1,7),(8,1,8),(9,2,1),(10,2,2),(11,2,3),(12,3,5),(13,3,6),(14,3,7),(15,4,1),(16,4,5),(17,4,8),(18,5,3);

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `ID` int(11) NOT NULL,
  `USER_NAME` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `USER_PWD` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `idx_user_name` (`USER_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `user` */

insert  into `user`(`ID`,`USER_NAME`,`USER_PWD`) values (1,'Zoe','123456'),(2,'Coder','23452a'),(3,'Code综艺圈','231235');

/*Table structure for table `user_role` */

DROP TABLE IF EXISTS `user_role`;

CREATE TABLE `user_role` (
  `ID` int(11) NOT NULL,
  `USER_ID` int(11) DEFAULT NULL,
  `ROLE_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `user_role` */

insert  into `user_role`(`ID`,`USER_ID`,`ROLE_ID`) values (1,1,1),(2,2,2),(3,2,3),(4,3,2),(5,3,5);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
```

演示用的版本是`MySql5.5`，各版本之间会有不同，所以小伙伴用的版本测试结果不一样的时候，千万别骂我渣哦；其实重要的是查看的思路，整体是大同小异。(求原谅......)

通过`explain`会输出如下信息，很多小伙伴只关注红框标注部分(即索引)，但其实是不够的，接下来就一个一个好好说说。

{% asset_img 2021-11-22-16-00-46.png %}

- `id`

    这个`id`和咱们平时表结构设计的主键`ID`不太一样，这里的`id`代表了每一条`SQL`语句执行计划中表加载的顺序，分为三种情况：

    > `id`相同的时候：这时是从上到下依次执行；
```sql
EXPLAIN SELECT t.ID,t.USER_NAME,r.ROLE_NAME FROM USER t 
	JOIN USER_ROLE tr ON t.ID = tr.USER_ID
	JOIN ROLE r ON tr.ROLE_ID = r.ID
```

执行如下语句，得如下结果：

{% asset_img 2021-11-22-16-03-34.png %}

如上图所示，`id`一样，从上到下依次执行，所对应表加载顺序为`t->tr->r`(这里的表是别名)；

    > `id`不同的时候：当`id`不同的时，`id`越大的越先执行；

```sql
EXPLAIN SELECT t.ID,t.MENU_NAME,t.MENU_URL FROM MENU t
	WHERE t.ID IN (SELECT MENU_ID FROM ROLE_MENU rm 
		WHERE rm.ROLE_ID IN(SELECT ROLE_ID FROM USER_ROLE ur WHERE ur.USER_ID=1))
```
子查询会导致`id`递增，结果如下：

{% asset_img 2021-11-22-16-05-35.png %}

如上图所示，`id`递增啦，所对应表的加载顺序为`ur->rm->t`(这里的表是别名)；

    > `id`相同和不同同时存在时：id相同的认为是同一组，还是从上往下加载；不一样的情况还是越大越优先执行

```sql
EXPLAIN SELECT t.ROLE_ID,m.ID,m.MENU_NAME,m.MENU_URL FROM 
	(SELECT ROLE_ID FROM USER_ROLE WHERE USER_ID=3) t,ROLE_MENU rm,MENU m
	WHERE t.ROLE_ID=rm.ROLE_ID
	AND rm.MENU_ID=m.ID
```

执行结果如下：

{% asset_img 2021-11-22-16-06-53.png %}

如上图所示，`id`有一样的，也有不同的，则对应表的加载顺序为`USER_ROLE->derived2 (衍生表)->rm->m`；衍生表表名后面的`2`代表的是`id`，所以可以通过衍生表表名后面的`id`知道是哪一步产生的，即`derived2`衍生表是`id`为`2`的这一步产生的。

- `select_type`

`select_type` 是表示每一步的查询类型，方便分析人员很直接的看到当前步骤执行的是什么查询，有多种类型，见下图：

 > 1> `SIMPLE`：简单的`SELECT`查询，不包含子查询或`UNION`的那种；

```sql
EXPLAIN SELECT * FROM USER;
```

输出结果如下：

{% asset_img 2021-11-22-16-13-44.png %}

> 2> `PRIMARY`：查询语句中包含其他子查询或`UNION`操作，那最外层的`SELECT`就被标记为该类型；

{% asset_img 2021-11-22-16-15-17.png %}

如上图所示，查询中包含子查询，最外层查询被标记为`PRIMARY`；

> 3> `SUBQUERY`：在`SELECT`或`WHERE`中包含的子查询会被标记为该类型；

见`PRIMARY`图，当存在子查询时，会将子查询标记为`SUBQUERY`

> 4> `MATERIALIZED`：被物化的子查询，即针对对应的子查询将其物化为一个临时表；

```sql
EXPLAIN SELECT t.ID,t.MENU_NAME,t.MENU_URL FROM MENU t
	WHERE t.ID IN (SELECT MENU_ID FROM ROLE_MENU rm 
		WHERE rm.ROLE_ID IN(SELECT ROLE_ID FROM USER_ROLE ur WHERE ur.USER_ID=1));
```
测试物化用的是`MySQL8.0`，和`5.*`版本有所不同，输出结果如下：

{% asset_img 2021-11-22-16-16-49.png %}

如上图所示，将子查询物化为一个临时表`subquery2`，这个功能是可以通过设置优化器对应的开关的。

> 5> `DERIVED`：在`FROM`之后的子查询会被标记为该类型，同样会把结果放在一个临时表中

```sql
EXPLAIN SELECT tm.MENU_NAME,rm.ROLE_ID FROM 
	(SELECT * FROM MENU WHERE ID >3 ) tm ,ROLE_MENU rm 
	WHERE tm.ID=rm.MENU_ID AND rm.ROLE_ID=1
```
输出结果：

{% asset_img 2021-11-22-16-17-39.png %}

如图所示，`FROM`后面跟的子查询就被标记为`DERIVED`，对应步骤产生的衍生表为`derived2`。高版本好像对其进行了优化，`8.0`版本这种形式认为是简单查询。

> 6> `UNION：UNION`操作中，查询中处于内层的`SELECT`；

```sql
EXPLAIN SELECT * FROM USER_ROLE T1 WHERE T1.USER_ID=1
UNION
SELECT * FROM USER_ROLE T2 WHERE T2.USER_ID=2
```
输出结果如下：

{% asset_img 2021-11-22-16-18-35.png %}

如上图所示，将第二个`SELECT`标注为`UNION` ，即对应加载的表为`T2`。

> 7> `UNIOIN RESULT：UNION`操作的结果，对应的`id`为空，代表的是一个结果集；

见`UNIOIN`图，`UNIOIN RESULT`代表的是`UNION`之后的结果，对应`id`为空。

- `table`

`table`代表对应步骤加载的是哪张表，中间会出现一些临时表，比如`subquery2、derived2`等这种，最后的数字代表产生该表对应步骤的`id`。

- `type`

代表访问类型，`MySQL`内部将其分为多类型，常用的类型从好到差的顺序展示如下：

**`system->const->eq_ef->ref->fulltext->ref_or_null->index_merge->unique_subquery->index_subquery->range->index->ALL;`**

而在实际开发场景中，比较常见的几种类型如下：`const->eq_ref->ref->range->index->ALL`(顺序从好到差)，通常优化至少在`range`级别或以上，比如`ref`算是比较不错的啦；

上面说到的从好到差指的是查询性能。

> 1>`const`：表示通过索引一次就找到数据，用于比较`primary key`或者`unique`索引，很快就能找到对应的数据；

{% asset_img 2021-11-22-16-21-32.png %}

> 2>`eq_ref`：唯一性索引扫描，对于每个索引键，表中只有一条记录与之匹配，常用于主键或唯一索引扫描；

{% asset_img 2021-11-22-16-22-02.png %}

> 3>`ref`：非唯一索引扫描，返回匹配的所有行，如建立一个朋友维护表，维护用户对应的朋友，而在用户`ID`建立非唯一索引；

{% asset_img 2021-11-22-16-22-32.png %}

> 4>`range`：使用一个索引检索指定范围的行，一般在`where`语句中会出现`between、<、>、in`等范围查询；

{% asset_img 2021-11-22-16-22-59.png %}

> 5>`index`：全索引扫描，只遍历索引树；

{% asset_img 2021-11-22-16-23-30.png %}

> 6>`ALL`：全表扫描，找到匹配行。与`index`比较，`ALL`需要扫描磁盘数据，`index`值需要遍历索引树。

{% asset_img 2021-11-22-16-23-57.png %}

- `possible_keys`

显示可能被用到的索引，但在实际查询中不一定能用到； 查询涉及到字段，如果存在索引，会被列出，但如果使用的是覆盖索引，只会在`key`中列出；

{% asset_img 2021-11-22-16-24-29.png %}

- `key`

实际使用到的索引，如果为`NULL`代表没有使用到索引；这也是平时小伙伴判断是否用上索引的关键。

- `key_len`

`key_len`表示索引使用的字节数，根据这个值可以判断索引的使用情况，特别是在组合索引的时候，判断该索引有多少部分被使用到，非常重要；`key_len`是根据表定义计算而得。这里测试在`USER`表中对`USER_NAME`创建一个非唯一索引，如下：

{% asset_img 2021-11-22-16-25-14.png %}

这里`key_len`是这么计算的，前提是指定的字符串集是`utf8`，可变长 且允许为空，计算过程如下：

`128(设置的可变长度)*3(utf8占3字节)+1(允许为空标识占一个字节)+2(长度信息占两个字节)=387；`

`key_len`针对不同类型字段的计算规则不一样，这里用`USER(用户表)`简单计算为例：

字段 | Key_len | 说明
----|---|---
`ID(int，不为空)` |	`4`	| ``int``为`4`个字节，不为空
`USER_NAME(varchar(128)，utf8，可为空)`	| `128*3+1+2=387` |	可变为`128，utf8`每个占`3`字节，`1`个字节标识可控，两个字节标识长度

不同类型占用的字节不一样，字符集不一样占用的字节也不一样，允许为空的字段需要`1`个字节做标识，可变长度的字段需要`2`个字节标识长度。小伙伴照着这个思路就可以计算其他类型啦。

- `ef`

显示索引的哪些列被引用了，通常是对应字段或`const`；
{% asset_img 2021-11-22-16-30-20.png %}
{% asset_img 2021-11-22-16-30-30.png %}

- `rows`

根据表统计信息和索引的使用情况，大概估算出找到所需记录数据所扫描的数据行数；不是所需数据的行数。

- `Extra`

这个字段里包含一些其他信息，但也是优化`SQL`的重要参考，通常会出现以下几种信息：

> `Using index`：表示查询语句中用到了覆盖索引，不访问表的数据行，查询效率比较好。

{% asset_img 2021-11-22-16-31-08.png %}

如果用`SELECT *`进行查询，就不会有`Using index`，关于索引的介绍下篇好好说说。

> `Using filesort`：代表`MySQL`会使用一个外部索引对数据进行排序(文件排序)，而不是使用表内索引。这种情况在`SQL`查询需要避免，最好不要在`Extra`中出现此类型：

{% asset_img 2021-11-22-16-32-01.png %}

通常会是使用`ORDER BY`语句导致，上图中使用无索引的字段进行排序会出现，同样如果使用有索引的字段，但用法不对也会出现，比如使用组合索引不规范时。

- `Using temporary`：产生临时表保存中间结果，这种SQL是不允许的，遇见数据量大的场景，基本就跑不动啦；

{% asset_img 2021-11-22-16-32-30.png %}

这种类型常常因为`ORDER BY` 和 `GROUP BY`导致，所以在进行数据排序和分组查询时，要注意索引的合理利用。

> `Using where`：使用`where`过滤数据，小伙伴试一把。

> `Using join buffer`：表示使用到了表连接缓存； 当表数据量大，可能导致`buffer`过大，查询效率比较低，这种情况注意在表连接字段上正确使用索引。

{% asset_img 2021-11-22-16-33-30.png %}

如果表连接查询慢时，在连接字段上加个索引试试，药到病除；

> `impossible where`：代表`where`后面的条件永远为`false`，匹配不到数据；

{% asset_img 2021-11-22-16-33-42.png %}




