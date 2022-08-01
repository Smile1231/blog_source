---
title: Machine Learning essays
hide: false
tags:
  - Machine Learning
  - numpy
  - pandas
  - sklearn
categories: Machine Learning
keywords:
  - Machine Learning
  - numpy
  - pandas
  - sklearn
abbrlink: 1b930e38
date: 2022-07-17 21:44:54
---

最近在看`数据挖掘`以及`ML`的课程

[数据挖掘资料](https://docs.hwl.cool/python/%E6%95%B0%E6%8D%AE%E6%8C%96%E6%8E%98/)

[numpy reference](https://www.numpy.org.cn/reference/)

[Sklearn Reference](https://scikit-learn.org/stable/modules/classes.html)

[WebGraph](http://webgraphviz.com/)

[Kaggle](https://www.kaggle.com/datasets/)

## `python`中的`head`方法

`head()`根据位置返回对象的前`n`行。 如果你的对象中包含正确的数据类型, 则对于快速测试很有用。 此方法用于返回数据帧或序列的前`n`行(默认值为`5`)。 `n：`它是指返回行数的整数值。


## `pandas`交叉表

交叉表是由列和行组成的双向表。 它也被称为数据透视表或多维表。 其最大的优势是能够构造、汇总及显示大量数据。 交叉表还可用于确定行变量与列变量之间是否存在关系。

[参考链接](https://docs.tibco.com/pub/spotfire_web_player/6.0.0-november-2013/zh-CN/WebHelp/GUID-1F67B2F3-056B-4324-B2CC-14D73D378693.html)


## 网格搜索（`GridSearchCV`）

`GridSearch和CV`，即网格搜索和交叉验证

网格搜索算法是一种通过遍历给定的参数组合来优化模型表现的方法

为何使用：超参数选择不恰当，就会出现欠拟合或者过拟合的问题

内容： 网格搜索，搜索的是参数，即在指定的参数范围内，按步长依次调整参数，利用调整的参数训练学习器，从所有的参数中找到在验证集上精度最高的参数，这其实是一个训练和比较的过程。

`Grid Search`：一种调参手段；穷举搜索：在所有候选的参数选择中，通过循环遍历，尝试每一种可能性，表现最好的参数就是最终的结果

用法：网格搜索适用于三四个（或者更少）的超参数（当超参数的数量增长时，网格搜索的计算复杂度会呈现指数增长，这时候则使用随机搜索），用户列出一个较小的超参数值域，这些超参数至于的笛卡尔积（排列组合）为一组组超参数。网格搜索算法使用每组超参数训练模型并挑选验证集误差最小的超参数组合

缺点：遍历所有组合，比较耗时

## 打印表头

```python
import pandas as pd
titanic = pd.read_csv("./titanic/train.csv")
print(titanic.columns)
```
{% asset_img 2022-07-29-13-01-44.png %}


## `pandas`的`inplace`参数

```inplace=True`函数不返回任何内容。它用所需的操作修改现有的`dataframe`，并在原始`dataframe`上“就地”（`inplace`）执行。

## 关于`python`中的随机种子——`random_state`

`random_state`是一个随机种子，是在任意带有随机性的类或函数里作为参数来控制随机模式。当`random_state`取某一个值时，也就确定了一种规则。

`random_state`可以用于很多函数，一般用于以下三个地方：1、训练集测试集的划分 2、构建决策树 3、构建随机森林


## 查看数据类型

```python
# type(a)   DataFrame数据类型

df.dtypes  #查看各列数据类型
df[A].dtypes  #查看A列数据类型

df[A].astypes(int)#将A列数据类型转换为int
```