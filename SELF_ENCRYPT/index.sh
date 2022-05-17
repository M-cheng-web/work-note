# 注意点:
# 1. 目前只支持纯文本文件(.md .text js html vue ...), 不支持 .doc .ppt 这样的文件
# 2. SELF_ENCRYPT 文件夹放在项目根目录
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
# 8. 以后可以绑定 git,根据git 钩子来自动加密


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

# echo $(ls | grep .js) 这样能拿到当前目录所有文件,然后 grep 筛选

# 哪里执行的命令,就以那个位置为基准,比如创建文件的时候如果直接写文件名,是直接创建在那个位置的


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

# 参数一: on / off / push / pull / nogit / back
#        on / off:    代表 加密,解密
#        push / pull: 代表 加密,解密 (会提交代码到远程)
#        nogit:       代表 加密的源码(SELF_ENCRYPT文件夹)不会提交到git
#        back:        代表 回滚上一次操作(为了防止加密解密错误)

# 参数二: files 需要加密的文件夹 (支持 all)

# 参数三: files 不需要加密的文件夹 (不支持 all)

if [ $1 = nogit ]
  then
  echo 'SELF_ENCRYPT' >> '.git/info/exclude'
elif [[ $1 = on || $1 = off || $1 = push || $1 = pull ]]
  then
  if [ $1 = on || $1 = off ]
    then
      sh SELF_ENCRYPT/kernel.sh $1 $2 $3
    elif then
      if [ $1 = push ]
        then
          # 先加密再推送
          sh SELF_ENCRYPT/kernel.sh on $2 $3
          sh SELF_ENCRYPT/push.sh $1
        else
          # 先拉取再解密
          sh SELF_ENCRYPT/push.sh $1
          sh SELF_ENCRYPT/kernel.sh off all
      fi
  fi
else
  echo '请输入正确的首位参数'
fi