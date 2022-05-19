# 回滚上一次操作(为了防止加密解密错误)

# 思路
# 1. 每次加密解密之前,都执行一下此方法
# 2. 此方法会创建一个 .back 文件夹,内部存放着一些备用文件
# 3. 每次加密解密后都会将处理过的文件放在 .back 文件夹中
# 4. 每次加密解密都会替换,比如第一次加密了五个文件,第二次加密了2个文件,回滚时只会有那2个文件

# 参数解释
# $1: 强制为 _self 时,代表开启私有方法 (用来备份)
# $2: 所有更改的文件集合

#!/usr/bin/env sh

set -e # 确保脚本抛出遇到的错误

cd `dirname $0` # 进入工作目录 (也就是 SELF_ENCRYPT内)

IFS=$'\n'

dir=".back"

if [ $1 = _self ]
  then
    # 备份
    if [ -e $dir ]; then rm -rf $dir; fi
    mkdir $dir
    cd ..
    files=`ls | grep -v SELF_ENCRYPT`
    cp -ax $files ./SELF_ENCRYPT/.back
  else
    # 回滚
    if [ -e $dir ]
      then
        cd ..
        cp -Rvf ./SELF_ENCRYPT/.back/* ./
      else
        echo "只有操作了文件才能进行回滚"
    fi
fi