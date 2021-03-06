# 店长超级详情 - PC
## 项目简介
超级详情是一套商品详情优化工具,让不会ps的用户也能轻松做设计,助力商家专心做好运营~

目前分有两个载体,这里着重介绍**PC端**
+ 移动端 ( H5 + 小程序 )
+ 网页端 ( H5 + 小程序 )

## 项目地址
采用 `小程序 + online 版H5页面` 方案,分为两个项目
+ 小程序 [superboss-itemdetail-miniapp-pc](https://git2.superboss.cc/raycloudFrontEnd/superboss-itemdetail-miniapp-pc)
+ H5端( online ) [superboss-itemdetail-web](https://git2.superboss.cc/raycloudFrontEnd/superboss-itemdetail-web)

## 开发项目
``` js
npm install        // 安装依赖
npm run dev        // 启动项目
npm run build      // 项目打包
npm run build-font // 压缩字体 (下面有详情说明)
```

### 文档库
+ /docs/**.md         项目开发规范文档
+ /docs/COMMONSASS.md 公共样式库 (样式库文档)

### 开发分支说明
由于本项目是小程序和H5结合的项目,H5端测试环境信息如下
+ 测试环境分支 master-gray
+ 测试环境域名 sudehd.superboss.cc

+ 正式环境分支 master
+ 正式环境域名 sude.superboss.cc

注意:
1. 从 `master` 分支切开发用的分支
2. 不要将 `master-gray` 与 `master` 合并
3. 测试环境发布仅需将自己的业务分支合并到 `master-gray` 即可,正式环境合并至 `master` 即可；


## 开发注意事项
### H5
1. 阅读项目内 `README.md` 文档
2. 通过 `my.postMessage` 或者 `my.onMessage` 来与小程序通信时要注意添加 `type` 属性(具体格式翻阅代码可知)
3. `细节图添加功能` 可调为是否为本地模式,如果是本地模式则可直接获取模板图片,而不是去调用小程序方法来添加图片
4. `文字添加功能` 是在进入输入文字页面时会触发 `focus()`来弹起键盘,如果改了相关功能要上本地手机验证是否弹起正常

#### 字体选择功能介绍(重要!!!)
当前有七种字体可供选择,这些字体都是在项目初始化时加载,目前采用 `字体预加载 + 本地压缩字体包`来尽量不影响首屏速度以及首次加载字体不会闪屏(preload + fontmin插件),经过测试 `fontmin插件` 能减少一半字体包体积

注意点:
1. 未来字体多了可能需要换成异步加载来减小带宽 (也就是用户通过点击字体的方式来加载字体,而不是一次性全请求)
2. 如果还是采用当前的字体包加载模式,在每次添加字体包时要看看下面的相关步骤 (fontmin插件 只是帮助我们过滤不想要的字体,并不能达到智能缩小字体包)

添加字体包具体步骤:
+ `src/buildFont/CommonChinese.js` 文件是文字模板文件,内容代表你想要压缩后的字体包只包含哪些字体
+ `src/buildFont/fontmin.js` 文件是压缩字体时执行的配置文件,比如说想要将压缩后的字体打包到哪个目录下就在此配置
+ fontmin插件只支持 `ttf格式` 字体,如果UI给的字体包是其他格式,可[在此转换](https://cloudconvert.com/)
+ 将新的字体包文件放置 `src/assets/font/oldfont` 目录下
+ 执行 `yarn build-font` 命令,可在 `src/assets/font/newfont` 目录下找到压缩后的字体包
+ 在 `src/font.css` 中添加加载字体方法
+ 随后在项目根路径中 `index.html` 中的 `<head>`标签内添加link标签设置预加载压缩后的字体包
+ 完成~

### 小程序
1. 阅读项目内 `README.md` 文档
2. 与 H5 端通信的主要文件地址 `client/pages/imageEditor/imageEditor.js` (比如细节图的选取照片,拍照)
3. `细节图添加功能`,由于拍照和选择手机图片会存在取消操作,而这种操作小程序返回给我们的errType是不固定的(不同的安卓手机不同的体现),所以安卓手机不设置取消后的提示弹窗
4. 提审前,**务必将 config/index.js 中的  env 设置为 online**