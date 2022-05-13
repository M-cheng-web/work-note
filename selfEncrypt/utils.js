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
 // 问题: 为了防止多次解密造成最终乱码,有什么办法能只对加密过的文本进行解密
const Decrypt = (text) => {
  const _text = Uint8Array.of(...text.split(','))
  return Aesjs.utils.utf8.fromBytes(_text)
}

/**
 * 加密 / 解密 文件
 * isEncrypt 加密 / 解密 (默认为 加密)
 */
function setFile(filePath, isEncrypt = true) {
  fs.readdirSync(filePath).forEach((filename) => {
    if (filename.charAt(0) === '.' || filename === 'selfEncrypt') return;
    const filedir = path.join(filePath, filename);
    const stat = fs.statSync(filedir)
    if (stat.isDirectory()) return setFile(filedir, isEncrypt);
    if (stat.isFile()) {
      const data = fs.readFileSync(filedir, 'utf-8')
      fs.writeFileSync(filedir, isEncrypt ? Encrypt(data) : Decrypt(data))
    }
  })
}

process.argv.forEach((val, index) => {
  if (index === 2 && val) {
    console.log('val', val);
    // const filePath = path.resolve(__dirname, val)
    // console.log('filePath', filePath);
    // setFile(filePath, false);
  };
});

// const filePath = path.resolve(__dirname, 'src')
// setFile(filePath, false);