---
title: The learning of Shell
hide: false
tags: Shell
categories: Shell
keywords: Shell
abbrlink: 55b095e0
date: 2022-05-10 23:35:17
---

Nowdays , i hava a task about how to use shell script ,so it is time to learn shell .


[ shell  入门 ](https://www.cnblogs.com/jingmoxukong/p/7867397.html)

[ 好用的工具网站 ](http://tool.rbtree.cn/)

<!-- more -->

## ``ALL``

[https://www.runoob.com/linux/linux-command-manual.html](https://www.runoob.com/linux/linux-command-manual.html)

## `zip`和`upzip`

```bash
# zip命令的选项说明
# -A：调整可执行的自动解压缩文件。
# -b<工作目录>：指定暂时存放文件的目录。
# -c：替每个被压缩的文件加上注释。
# -d：从压缩文件内删除指定的文件。
# -D：压缩文件内不建立目录名称。
# -f：此参数的效果和指定"-u"参数类似，但不仅更新既有文件，如果某些文件原本不存在于压缩文件内，使用本参数会一并将其加入压缩文件中。
# -F：尝试修复已损坏的压缩文件。
# -g：将文件压缩后附加在既有的压缩文件之后，而非另行建立新的压缩文件。
# -h：在线帮助。
# -i<范本样式>：只压缩符合条件的文件。
# -j：只保存文件名称及其内容，而不存放任何目录名称。
# -J：删除压缩文件前面不必要的数据。
# -k：使用MS-DOS兼容格式的文件名称。
# -l：压缩文件时，把LF字符置换成LF+CR字符。
# -ll：压缩文件时，把LF+CR字符置换成LF字符。
# -L：显示版权信息。
# -m：将文件压缩并加入压缩文件后，删除原始文件，即把文件移到压缩文件中。
# -n<字尾字符串>：不压缩具有特定字尾字符串的文件。
# -o：以压缩文件内拥有最新更改时间的文件为准，将压缩文件的更改时间设成和该文件相同。
# -q：不显示指令执行过程。
# -r：递归处理，将指定目录下的所有文件和子目录一并处理。
# -S：包含系统和隐藏文件。
# -t<日期时间>：把压缩文件的日期设成指定的日期。
# -T：检查备份文件内的每个文件是否正确无误。
# -u：更换较新的文件到压缩文件内。
# -v：显示指令执行过程或显示版本信息。
# -V：保存VMS操作系统的文件属性。
# -w：在文件名称里假如版本编号，本参数仅在VMS操作系统下有效。
# -x<范本样式>：压缩时排除符合条件的文件。
# -X：不保存额外的文件属性。
# -y：直接保存符号连接，而非该连接所指向的文件，本参数仅在UNIX之类的系统下有效。
# -z：替压缩文件加上注释。
# -$：保存第一个被压缩文件所在磁盘的卷册名称。
# -<压缩效率>：压缩效率是一个介于1-9的数值。

$zip -m new_zip_name old_filename

```

```bash
# 解压到当前目录 如果文件已存在，会提示是否替换，可以使用 -o 或 -n 参数简化交互；
$unzip test.zip

# 解压到指定目录 解压后的文件路径:/{targetPath}/test
$unzip -d {targetPath} test.zip 

# 不覆盖已经存在的文件
$unzip -n test.zip

#强制覆盖已经存在的文件
$unzip -o test.zip

#查看压缩包中的文件列表
# 文件大小、时间、文件名称 不进行解压缩
$unzip -l test.zip

# 查看压缩包中的文件信息【更详细】 
# 文件大小、压缩比、日期、文件名称
$unzip -v test.zip

# 检查压缩包是否损坏
$unzip -t test.zip

# 显示压缩文件的备注
$unzip -z test.zip


# 执行解压不显示任何信息
$unzip -q test.zip
$unzip -oq test.zip # 静默解压没有任何提示

```

## `Bash shell`脚本打印出正在执行的命令

```bash
# 默认情况下，bash脚本不会打印执行的每个命令，这个有时候不太方面。
# 如下的方法可以让bash脚本打印出执行的命令：
1） 在脚本里添加 
    set -v 或者
    #!/bin/bash -v

    以加 set -v 最好。

    set -v  和 set -o verbose  是一样的

2) 添加
    set -x 

    或者
    #!/bin/bash -x

```

## `sed`指令

[ 参考地址 ](http://c.biancheng.net/view/4028.html)

`sed` 命令的基本格式如下：`sed [选项] [脚本命令] 文件名`

该命令常用的选项及含义:

选项 |	含义
---- |---
`-e` | 脚本命令	该选项会将其后跟的脚本命令添加到已有的命令中。
`-f` | 脚本命令文件	该选项会将其后文件中的脚本命令添加到已有的命令中。
`-n` |	默认情况下，`sed` 会在所有的脚本指定执行完毕后，会自动输出处理后的内容，而该选项会屏蔽启动输出，需使用 `print` 命令来完成输出。
`-i` |	此选项会直接修改源文件，要慎用。

### `sed s `替换脚本命令
此命令的基本格式为：
```bash
# 其中，address 表示指定要操作的具体行，pattern 指的是需要替换的内容，replacement 指的是要替换的新内容。
[address]s/pattern/replacement/flags
```
其中`flag`:

`flags` 标记 | 功能
----|---
`n` |	`1~512` 之间的数字，表示指定要替换的字符串出现第几次时才进行替换，例如，一行中有 `3` 个 `A`，但用户只想替换第二个 `A`，这是就用到这个标记；
`g` |	对数据中所有匹配到的内容进行替换，如果没有 `g`，则只会在第一次匹配成功时做替换操作。例如，一行数据中有 `3` 个 `A`，则只会替换第一个 `A`；
`p` |	会打印与替换命令中指定的模式匹配的行。此标记通常与 `-n` 选项一起使用。
`w file` |	将缓冲区中的内容写到指定的 `file` 文件中；
`&` |	用正则表达式匹配的内容进行替换；
`\n` |	匹配第 `n` 个子串，该子串之前在 `pattern` 中用 \(\) 指定。
`\` |	转义（转义替换部分包含：`&、\` 等）。

> `tips`  -- 需要转义的一些字符:

{% asset_img 2022-05-13-00-07-09.png %}

1. 比如，可以指定 `sed` 用新文本替换第几处模式匹配的地方：
    ```bash
    $sed 's/test/trial/2' data4.txt
    This is a test of the trial script.
    This is the second test of the trial script.
    ```
    可以看到，使用数字 `2` 作为标记的结果就是，`sed` 编辑器只替换每行中第 `2` 次出现的匹配模式。

2. 如果要用新文件替换所有匹配的字符串，可以使用 `g` 标记：
    ```bash
    $sed 's/test/trial/g' data4.txt
    This is a trial of the trial script.
    This is the second trial of the trial script.
    ```
3. 我们知道，`-n` 选项会禁止 `sed` 输出，但 `p` 标记会输出修改过的行，将二者匹配使用的效果就是只输出被替换命令修改过的行，例如：
    ```bash
    $cat data5.txt
    This is a test line.
    This is a different line.
    $sed -n 's/test/trial/p' data5.txt
    This is a trial line.
    ```
4. `w` 标记会将匹配后的结果保存到指定文件中，比如：
    ```bash
    $sed 's/test/trial/w test.txt' data5.txt
    This is a trial line.
    This is a different line.
    $#cat test.txt
    This is a trial line.
    ```
5. 在使用 `s` 脚本命令时，替换类似文件路径的字符串会比较麻烦，需要将路径中的正斜线进行转义，例如：
    ```bash
    sed 's/\/bin\/bash/\/bin\/csh/' /etc/passwd
    ```
### `sed d` 替换脚本命令
此命令的基本格式为：`[address]d`

如果需要删除文本中的特定行，可以用 `d` 脚本命令，它会删除指定行中的所有内容。但使用该命令时要特别小心，如果你忘记指定具体行的话，文件中的所有内容都会被删除，举个例子：
```bash
$cat data1.txt
The quick brown fox jumps over the lazy dog
The quick brown fox jumps over the lazy dog
The quick brown fox jumps over the lazy dog
The quick brown fox jumps over the lazy dog
$sed 'd' data1.txt
#什么也不输出，证明成了空文件
```

1. 通过行号指定，比如删除 `data6.txt` 文件内容中的第 `3` 行：
    ```bash
    $cat data6.txt
    This is line number 1.
    This is line number 2.
    This is line number 3.
    This is line number 4.
    $sed '3d' data6.txt
    This is line number 1.
    This is line number 2.
    This is line number 4.
    ```

2. 或者通过特定行区间指定，比如删除 `data6.txt` 文件内容中的第 `2、3` 行：
    ```bash
    $sed '2,3d' data6.txt
    This is line number 1.
    This is line number 4.
    ```

3. 也可以使用两个文本模式来删除某个区间内的行，但这么做时要小心，你指定的第一个模式会“打开”行删除功能，第二个模式会“关闭”行删除功能，因此，`sed` 会删除两个指定行之间的所有行（包括指定的行），例如：
    ```bash
    $sed '/1/,/3/d' data6.txt
    #删除第 1~3 行的文本数据
    This is line number 4.
    ```

4. 或者通过特殊的文件结尾字符，比如删除 `data6.txt` 文件内容中第 `3` 行开始的所有的内容：
    ```bash
    $sed '3,$d' data6.txt
    This is line number 1.
    This is line number 2.
    ```

在此强调，在默认情况下 `sed` 并不会修改原始文件，这里被删除的行只是从 `sed` 的输出中消失了，原始文件没做任何改变。

[ 完整版参考地址 ](http://c.biancheng.net/view/4028.html)

## `Grep`指令

[ 菜鸟链接 ](https://www.runoob.com/linux/linux-comm-grep.html)


## `awk`指令

[ 菜鸟链接 ](https://www.runoob.com/linux/linux-comm-awk.html)

[ good 1 ](https://www.cnblogs.com/ggjucheng/archive/2013/01/13/2858470.html)

## `cut`指令

[ 菜鸟链接 ](https://www.runoob.com/linux/linux-comm-cut.html)


[ 三剑客链接 ](https://www.cnblogs.com/along21/p/10366886.html)

## `JSON`格式化工具`jq`指令
 
[ 参考链接 ](https://www.cnblogs.com/kevingrace/p/7565371.html)

## `awk`内置函数`(split/substr/length/gsub)`

一、`split` 初始化和类型强制

`awk`的内建函数`split`允许你把一个字符串分隔为单词并存储在数组中。你可以自己定义域分隔符或者使用现在`FS(域分隔符)`的值。
格式：
```bash
split (string, array, field separator)
split (string, array) –>如果第三个参数没有提供，awk就默认使用当前FS值。
```
> 例子：
```bash
#!/bin/bash  
time="12:34:56"  
out=`echo $time | awk '{split($0,a,":");print a[1],a[2],a[3]}'`  
echo $out  
#输出：
#12 34 56  
```

计算指定范围内的和(计算每个人`1`月份的工资之和)：
```bash
# test.txt:
# Tom　　  2012-12-11      car     53000  
# John　　 2013-01-13      bike    41000  
# vivi    2013-01-18      car     42800  
# Tom　　  2013-01-20      car     32500  
# John　　 2013-01-28      bike    63500  

#`awk`处理命令：

awk '{split($2,a,"-");if(a[2]==01){b[$1]=b[$1]+$4}}END{for(i in b)print i,b[i]}' test.txt   
#输出结果：
# Tom　　 32500  
# vivi 42800  
# John　　 104500  
```

二、`substr` 截取字符串

返回从起始位置起，指定长度之子字符串；若未指定长度，则返回从起始位置到字符串末尾的子字符串。
格式：
```bash
substr(s,p) 返回字符串s中从p开始的后缀部分
substr(s,p,n) 返回字符串s中从p开始长度为n的后缀部分
```
> 例子：
```bash
echo "abc" | awk '{print substr($0,2,2)}'  
#输出结果：
# bc  
# 解释：
# awk -F ',' '{print substr($3,6)}'    --->  表示是从第3个字段里的第6个字符开始，一直到设定的分隔符","结束.
# substr($3,10,8)  --->  表示是从第3个字段里的第10个字符开始，截取8个字符结束.
# substr($3,6)     --->  表示是从第3个字段里的第6个字符开始，一直到结尾
```
三、`length` 字符串长度

`length`函数返回没有参数的字符串的长度。`length`函数返回整个记录中的字符数。
```bash
echo "abc" | awk '{print length}'   
# 结果：
# 3  
```


四、`gsub`函数

gsub函数则使得在所有正则表达式被匹配的时候都发生替换。`gsub(regular expression, subsitution string, target string);简称 gsub（r,s,t)`。

举例：把一个文件里面所有包含 `abc` 的行里面的 `abc` 替换成 `def`，然后输出第一列和第三列
```bash
echo "abc cde abr" | awk '$0 ~ /abc/ {gsub("abc","def",$0); print $1, $3}'  
# 输出结果：
# def abr 
```

## `Linux shell` 将字符串分割成数组
```bash
a="one,two,three,four"
# 要将$a分割开，可以这样：

OLD_IFS="$IFS"
IFS=","
arr=($a)
IFS="$OLD_IFS"
for s in ${arr[@]}
do
echo "$s"
done

# arr=($a)用于将字符串$a分割到数组$arr ${arr[0]} ${arr[1]} ... 分别存储分割后的数组第1 2 ... 项 ，${arr[@]}存储整个数组。变量$IFS存储着分隔符，这里我们将其设为逗号 "," OLD_IFS用于备份默认的分隔符，使用完后将之恢复默认。
```

## `linux`截取中间字符串,`shell`截取指定字符串之间的内容

```bash
#!/bin/bash

#截取字符串
#path=ss/usr/share/src/root/home/admin
path=ss/usr/share/src/root/home/admin/src/add
echo $path
echo ${path%src*} #从右向左截取第一个 src 后的字符串
echo ${path}
echo ${path%/*}从右向左截取 第一个 / 后的字符串
echo ${path%%/*}从右向左截取 最后一个 / 后的字符串
echo ${path#*/}从左向右截取第一个 / 后的字符串
echo ${path##*/}从左向右截取最后一个 / 后的字符串
echo ${path:3}
echo ${path:6:60}截取变量path从前三个字符串
echo ${#path}计算 path变量 一共有几个字符串
echo ${path/root/kyo}把path变量里的第一个root字符串，替换为 kyo字符串
echo ${path//s/m}把path变量里的所有的s字符，替换为 m 字符
echo ${path}
```

## `Shell`环境生成`UUID`

```bash
UUID=$(uuidgen |sed 's/-//g')
echo $UUID
# 918c61bd48914f0e8fb1295208b6e87e
```
## `Shell`中`$` 各种含义

符 号 |	含 义
----|---
`$0` |	脚本名
`$#` |	参数个数
`$n` |	传递给脚本的参数值，`$1`第`1`参数、`$2`第`2`参数
`$?`|	上次退出的状态（返回值），`0`没有错误，`1`错误
`$*` |	所有参数列表。`"$*"`时，是`"$1 $2 … $n"`的形式
`$@` |	所有参数列表。`"$@"`时，是`"$1" "$2" … "$n" `的形式
`$$` |	当前进程的编号`（ProcessID）`
`$!` |	`shell`最后运行的后台`Process`的`PID`
`$var` |	变量，会与后面的连接，如`$var_a`，会当做变量`var_a`
`${var}` |	变量，界定范围
`$()`	 | 与``(反引号)类似，里面执行完再返回值，``所有`shell`通用
`$[]` |	可进行算术运算和逻辑运算，不支持浮点和字符串
`$(())`  |	可进行算术运算和逻辑运算，不支持浮点和字符串。里面的变量可以省略`$`

## `linux` 下`shell`中`if`的`“-e，-d，-f”`是什么意思

```bash
文件表达式
-e filename 如果 filename存在，则为真
-d filename 如果 filename为目录，则为真 
-f filename 如果 filename为常规文件，则为真
-L filename 如果 filename为符号链接，则为真
-r filename 如果 filename可读，则为真 
-w filename 如果 filename可写，则为真 
-x filename 如果 filename可执行，则为真
-s filename 如果文件长度不为0，则为真
-h filename 如果文件是软链接，则为真
filename1 -nt filename2 如果 filename1比 filename2新，则为真。
filename1 -ot filename2 如果 filename1比 filename2旧，则为真。


整数变量表达式
-eq 等于
-ne 不等于
-gt 大于
-ge 大于等于
-lt 小于
-le 小于等于


字符串变量表达式
If  [ $a = $b ]                 如果string1等于string2，则为真
                                字符串允许使用赋值号做等号
if  [ $string1 !=  $string2 ]   如果string1不等于string2，则为真       
if  [ -n $string  ]             如果string 非空(非0），返回0(true)  
if  [ -z $string  ]             如果string 为空，则为真
if  [ $sting ]                  如果string 非空，返回0 (和-n类似) 


    逻辑非 !                   条件表达式的相反
if [ ! 表达式 ]
if [ ! -d $num ]               如果不存在目录$num


    逻辑与 –a                   条件表达式的并列
if [ 表达式1  –a  表达式2 ]


    逻辑或 -o                   条件表达式的或
if [ 表达式1  –o 表达式2 ]
```

## `shell`获取文件扩展名

```bash
basename example.tar.a.b.c.gz .c.gz
# => example.tar.a.b
 
FILE="example.tar.gz"
 
echo "${FILE%%.*}"     取头   example 
# => example
 
echo "${FILE%.*}"      去尾   example.tar.a.b.c
# => example.tar
 
echo "${FILE#*.}"      去头   tar.a.b.c.gz
# => tar.gz
 
echo "${FILE##*.}"     取尾   gz
# => gz
 
# 在bash中可以这么写
filename=$(basename "$fullfile")   
extension="${filename##*.}"
filename="${filename%.*}"
```

## `Linux shell` 中获取当前目录的方法
> 当前目录

每当你在终端进行操作时，你都会有一个当前工作目录。 使用pwd来判定当前目录在文件系统内的确切位置。
```bash
$pwd
/root
```
在`shell`中也可以使用`pwd`来获取当前目录，并赋值给变量。
```bash
#!/bin/bash
CRTDIR=$(pwd)
```
> 工作目录

获取当前执行的脚本文件的父目录。
```bash
workdir=$(cd $(dirname $0); pwd)
```
> 复杂点的工作目录获取
```bash
PRG="$0"
while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
PRGDIR=$(cd $(dirname $PRG); pwd)
```
## `Linux Shell`获取文件夹下的文件名
```bash
#!/bin/bash
# get all filename in specified path
path=$1
files=$(ls $path)
for filename in $files
do
   echo $filename >> filename.txt
done
```

## `shell`获取目录下所有文件夹的名称并输出

```bash
#!/bin/bash
#方法一 
dir=$(ls -l /usr/ |awk '/^d/ {print $NF}')
or i in $dir
do
    echo $i
done   
#######
#方法二
for dir in $(ls /usr/)
do
    [ -d $dir ] && echo $dir
done        
##方法三
ls -l /usr/ |awk '/^d/ {print $NF}'   ## 其实同方法一，直接就可以显示不用for循环
```


## 常用 `Linux jq`命令语法整理

[参考链接](https://blog.csdn.net/Cheat1173010256/article/details/118230562#:~:text=JQ%20%E6%98%AF%E4%B8%80%E4%B8%AA%20%E5%91%BD%E4%BB%A4%20%E8%A1%8C%E5%B7%A5%E5%85%B7%EF%BC%8C%E4%B8%BB%E8%A6%81%E7%94%A8%E4%BA%8E%E5%A4%84%E7%90%86json%E6%96%87%E6%9C%AC%E3%80%82%20%E8%AF%AD%E6%B3%95,%E5%BE%88%E7%AE%80%E5%8D%95%EF%BC%8C%E5%A6%82%E4%B8%8B%EF%BC%9A%20jq%20%5Boptions...%5D%20filter%20%5Bfiles...%5D)

{% asset_img 2022-05-13-20-25-50.png %}

{% asset_img 2022-05-13-20-26-18.png %}

{% asset_img 2022-05-13-20-26-42.png %}

{% asset_img 2022-05-13-20-27-00.png %}


## `shell`脚本中整数型变量自增（加`1`）的实现方式

```shell
#!/bin/sh
#本脚本测试shell脚本中整型变量自增 加1的几种方法
 
#定义整型变量
a=1
echo $a
 
#第一种整型变量自增方式
a=$(($a+1))
echo $a
 
#第二种整型变量自增方式
a=$[$a+1]
echo $a
 
#第三种整型变量自增方式
a=`expr $a + 1`
echo $a
 
#第四种整型变量自增方式
let a++
echo $a
 
#第五种整型变量自增方式
let a+=1
echo $a
 
#第六种整型变量自增方式
((a++))
echo $a
```

## `shell`判断一个变量是否为空

```shell
[ ! $a ] && echo "a is null" 


#!/bin/sh 
a= 
if [ ! -n "$a" ]; then 
echo "IS NULL" 
else 
echo "NOT NULL" 
fi

#!/bin/sh 
a= 
if [ ! $a ]; then
echo "IS NULL" 
else 
echo "NOT NULL" 
fi

#!/bin/sh 
a= 
if test -z "$a" then 
echo "a is not set!" 
else 
echo "a is set !" 
fi

#!/bin/sh 
a= 
if [ "$a" = "" ]; then 
echo "a is not set!" 
else 
echo "a is set !" 
fi
```

## 输出到文件

```shell
#两种方法：
2>&1 | tee mylog.log
> test.txt
#举例：
------------------------------------------------------------
sh batchjob.sh 2>&1 | tee mylog.log
ls * > test.txt
-------------------------------------------------------------
find ./ -name "*.xml" > result.txt
find ./ -name "*.xml" 2>&1 | tee mylog.log
```

## `Shell` 实现多线程（多任务）

1. 命令结尾添加：`&`
2. 解决主线程提前退出问题，添加 `wait`
3. 控制后台执行数（线程数），`mkfifo`

[https://www.cnblogs.com/zhengbin/p/9513762.html](https://www.cnblogs.com/zhengbin/p/9513762.html)





