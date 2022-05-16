: << !
这边是初始化脚本
目的是将脚本隐藏起来,以后直接通过命令来操作文件(也是为了不提交到git上)
!


#!/usr/bin/env sh

echo 1

mv selfEncrypt .selfEncrypt

# filePath=".test_file.zzz"
# touch $filePath
# echo "hello liyang" > $filePath
# echo "文件创建完成"
# else
# echo "文件已经存在"
# fi