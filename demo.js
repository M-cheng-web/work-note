const process = require('process')
const fs = require('fs')
const path = require('path')
const Aesjs = require('./aes')

 // 加密 (伪加密,只是转了一下格式,有需要可以直接用 aesjs 的对称加密)
const Encrypt = (text) => {
  const _text = Aesjs.utils.utf8.toBytes(text)
  return _text.toString();
}

 // 解密
const Decrypt = (text) => {
  const _text = Uint8Array.of(...text.split(','))
  return Aesjs.utils.utf8.fromBytes(_text)
}

process.argv.forEach((val, index) => {
  if (index === 2) setFile(val, true);
});

const filePath = './src'
setFile(filePath, true)

/**
 * 加密 / 解密 文件
 * isEncrypt 默认为 加密文件
 */
function setFile(filePath, isEncrypt = true) {
  fs.readdirSync(filePath).forEach((filename) => {
    console.log('filename', filename);
    const filedir = path.join(filePath, filename);
    const stat = fs.statSync(filedir)
    if (stat.isDirectory()) return setFile(filedir, isEncrypt);
    if (stat.isFile()) {
      console.log('filedir', filedir);
      const data = fs.readFileSync(filedir, 'utf-8')
      fs.writeFileSync(filedir, isEncrypt ? Encrypt(data) : Decrypt(data))
    }
  })
}