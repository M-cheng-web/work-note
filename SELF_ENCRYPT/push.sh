#!/usr/bin/env sh

# 负责提交代码 / 更新代码

defaultBranch=main

if [ $1 = push ]
  then
    # git add -A
    # git commit -m 'feat: 每日任务'
    # git $1 origin $defaultBranch
fi

git $1 origin $defaultBranch
