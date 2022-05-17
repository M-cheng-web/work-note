#!/usr/bin/env sh

# 负责提交代码 / 更新代码

defaultBranch=main
defaultCommit="feat: 每日任务"

if [ $1 = push ]
  then
    git add -A
    git commit -m $defaultCommit
fi

echo git $1 origin $defaultBranch....

git $1 origin $defaultBranch
