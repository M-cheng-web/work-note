# 注意点:
# 1. 目前只支持纯文本文件(.md .text js html vue ...), 不支持 .doc .ppt 这样的文件
# 2. selfEncrypt 文件夹放在项目根目录
# 3. 执行脚本时 要求在项目根路径执行
# 4. 传参不能手动传 *, 要传 all, 传 * 会将路径解析出来再给到脚本,这样不行
# 5. 这里的遍历不会找出隐藏文件,暂时也不需要找出隐藏文件



# 额外记录
# '*' 和 * 是不一样的, '*' 作为参数 => $1 = (fileA fileB fileC)
# * 作为参数 => $1 = fileA   $2 = fileB   $3 = fileC


# 参数规则
# $1 push / pull
# $2 需要加密的文件夹

# 文件夹参数规则
# 指定需要遍历的文件夹(以项目根目录为基础,分以下几种情况)
# 1. 不给参数 - 加密项目下所有文件 (除去 . 开头的隐藏文件, 和 selfEncrypt 文件)
# 2. 给一个参数 - 只需要给定从项目根目录开始,哪个文件夹下的文件加密
#    如: sh index.sh 'src' (代表项目根目录下 src 文件夹下所有文件)
#    如: sh index.sh 'demo' (代表项目目录下所有名为 demo 文件夹下的文件)
#    如: sh index.sh 'demo.js' (代表项目目录下所有名为 demo 文件夹下的文件)
#    如: sh index.sh 'src/demo/hu.js' (代表项目根目录下 src 文件夹下 demo 文件夹下 hu.js 文件)
#    如: sh index.sh ['src', 'src2/demo'] (代表项目根目录下 src 文件夹下所有文件, 以及src2/demo文件夹下所有文件)
# 3. 给两个参数 - 第一个参数代表需要加密的,第二个参数代表不需要加密的
#    如: sh index.sh 'src' 'src/demo' (代表加密项目根目录下 src 文件夹下所有文件,除 src/demo 下的文件)

#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

# 保证文件遍历正常(不会因为空格所影响)
IFS=$'\n'

# 1. pull / push
# 2. 需要加密的文件夹
# 3. 不需要加密的文件夹
ParamsA=$1
ParamsB=$2
ParamsC=$3
ParamsCArr=(${ParamsC[@]} selfEncrypt)

echo '不遍历的数组' ${ParamsCArr[@]}

function getdir() {
  for file in $*.js
  do
    if test -f $file
    then
      echo $file
      # for ex in $ParamsCArr
      # do
      #   if [ ${file} = 'all' ]
      #   fileArr=(${fileArr[@]} $file)
      # done
    else
      getdir $file/*
    fi
  done
}

if [ ${ParamsB} = 'all' ]
  then
    # 遍历所有文件
    getdir *
  else
    # 遍历特定文件
    getdir 
fi


echo ${fileArr[@]}

# node ./selfEncrypt/utils.js '../'$1

# node ./selfEncrypt/utils.js ${fileName}

# git add -A
# git commit -m 'feat: 每日任务'
# git push origin main