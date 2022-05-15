# 注意点:
# 1. 目前只支持纯文本文件(.md .text js html vue ...), 不支持 .doc .ppt 这样的文件
# 2. selfEncrypt 文件夹放在项目根目录
# 3. 执行脚本时 要求在项目根路径执行
# 4. 传参不能手动传 *, 要传 all, 传 * 会将路径解析出来再给到脚本,这样不行
# 5. 这里的遍历不会找出隐藏文件,暂时也不需要找出隐藏文件
# 6. 文件取名不能带有空格 (可以取名,但是在指定文件加密或者解密时会因为空格问题导致不能正确指定文件bug)
# 7. 目前是依赖于 node 环境的 (没有node环境将无效~)


# 待做
# 1. 需要正确辨别已加密的文件,要不然多次pull 也会搞乱格式
# 2. 对文件夹隐藏,这样感官会更好,而且如果是用 git的情况下,也会把这个文件提交,这是不合理的吧
# 3. 目前是依赖于 node环境的,希望shell能一把嗦
# 4. 目前是防君子不防小人~~
# 5. 增加防错功能,再加密错误后能倒退
# 6. 可选是否要提交 git
# 7. 最后可做成俩个文件,一个是普通的加密,一个是带git提交更新的文件


# 额外记录
# '*' 和 * 是不一样的, '*' 作为参数 => $1 = (fileA fileB fileC)
# * 作为参数 => $1 = fileA   $2 = fileB   $3 = fileC

# 这种方式比较的会有误差
# 比如: arr=(demo abc) file=demo2 也会匹配上
# if [[ "${arr[@]}" = "$file" ]]
#   then
#     # 在数组内
#     echo '不遍历的文件夹: '$file
#   else
#     # 不在数组内
# fi

# 带有空格的入参,比如 'a b c',会自动可以被遍历的 (for in 遍历带空格的都可以进行遍历)

# 加密的几种方案
# 1. 对比修改时间 (这个存在很多不确定性, 否)
# 2. 加密后的文件内容加一些自己的内容,解密的时候 (可)
# 3. 加密后的文件添加自己的后缀名 (可)


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

# 1. pull / push
# 2. 需要加密的文件夹
# 3. 不需要加密的文件夹
# 这里为什么要创建值接收一下? 因为直接这样操作会报错: (${3[@]} selfEncrypt)
ParamsA=$1
ParamsB=$2
ParamsC=$3

# 入参封装层
ParamsCArr=(${ParamsC[@]} selfEncrypt)

# 判断 $file 是否在数组 $ParamsCArr 内
function includeFile() {
  # 保证文件遍历正常(不会因为空格所影响)
  IFS=$'\n'
  isPass=true
  for ex in ${ParamsCArr[@]}
  do
    if [ $ex = $1 ]
      then isPass=false
    fi
  done
}

function getdir() {
  # 保证文件遍历正常(不会因为空格所影响)
  IFS=$'\n'
  for file in $*
  do
    includeFile $file
    if ${isPass}
      then
        if test -f $file
          then fileArr=(${fileArr[@]} $file)
          else getdir $file/*
        fi
      # else
        # echo '不遍历的文件夹: '$file
    fi
  done
}

for infile in ${ParamsB[@]}
do
  if [ $infile = 'all' ]
    then
      # 遍历所有文件
      getdir *
      break
    else
      # 遍历特定文件
      getdir $infile
  fi
done

# 得到真正需要加密(或者解密)的文件数组
# echo ${fileArr[@]}

if [ -z $fileArr ]
  then echo 根据规则选取的文件数为0,请重新选择
  else
    # node ./selfEncrypt/utils.js $1 ${fileArr[@]}

    # 对加密后的文件添加后缀名
    echo ${fileArr[@]}
fi


# git add -A
# git commit -m 'feat: 每日任务'
# git push origin main