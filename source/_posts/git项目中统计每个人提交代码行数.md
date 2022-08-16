---
title: git项目中统计每个人提交代码行数
hide: false
tags: git
categories: git
keywords: git
abbrlink: 2543b551
date: 2022-08-16 21:33:38
---

发现一个很有趣的，统计`git`项目中每个人提交代码的行数
```git
git log --format='%aN' | sort -u | while read name; do echo -en "作者： $name\t"; git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "添加行数: %s, 删除的行数: %s, 代码总行数: %s\n", add, subs, loc }' -; done
```

{% asset_img 2022-08-16-21-34-50.png %}