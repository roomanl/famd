import 'dart:io';
// import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import "package:pointycastle/export.dart";

import '../native_channel_utils.dart';

var logger = Logger();

// 将十六进制字符串转换为字节数组
Uint8List hexStringToByteArray(String hex) {
  // 如果字符串以 '0x' 开头，去掉它
  if (hex.startsWith('0x')) {
    hex = hex.substring(2);
  }

  // 确保十六进制字符串的长度是偶数
  if (hex.length % 2 != 0) {
    hex = '0$hex';
  }
  // 创建字节数组并将每两个十六进制字符解析为一个字节
  Uint8List bytes = Uint8List(hex.length ~/ 2);
  for (int i = 0; i < hex.length; i += 2) {
    bytes[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
  }
  return bytes;
}

/// 解密ts文件,解码较慢
Future<bool> decryptTs(
    {required String tsPath,
    required String savePath,
    String? keystr,
    String? ivstr,
    Uint8List? byteKey,
    Uint8List? byteIv,
    int decryptMode = 1}) async {
  final List<int> decrypted;
  try {
    File tsfile = File(tsPath);
    if (!tsfile.existsSync()) {
      return false;
    }
    final encryptedData = await tsfile.readAsBytes();
    if (ivstr == null && byteIv == null) {
      ivstr = '0x00000000000000000000000000000000';
    }
    Uint8List key = byteKey ?? Uint8List.fromList(keystr!.codeUnits);
    Uint8List iv = byteIv ?? hexStringToByteArray(ivstr!);
    //Android调用原生解码更快
    if (Platform.isAndroid) {
      final bytes = await decryptTS(tsPath, key, iv);
      if (bytes.isNotEmpty) {
        return saveDecryptTs(savePath, bytes);
      }
    }
    // 如果不是Android平台或者Android原生解密失败，使用Dart加密解密
    final keySpec = encrypt.Key(key);
    final ivSpec = encrypt.IV(iv);

    if (decryptMode == 1) {
      //解码很快
      CBCBlockCipher cipher = CBCBlockCipher(AESFastEngine());
      ParametersWithIV<KeyParameter> params =
          ParametersWithIV<KeyParameter>(KeyParameter(key), iv);
      PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>
          paddingParams =
          PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
              params, null);
      PaddedBlockCipherImpl paddingCipher =
          PaddedBlockCipherImpl(PKCS7Padding(), cipher);
      paddingCipher.init(false, paddingParams);
      decrypted = paddingCipher.process(encryptedData);
    } else {
      //解码较慢
      final encrypter =
          encrypt.Encrypter(encrypt.AES(keySpec, mode: encrypt.AESMode.cbc));
      decrypted =
          encrypter.decryptBytes(encrypt.Encrypted(encryptedData), iv: ivSpec);
    }

    return saveDecryptTs(savePath, decrypted);
  } catch (e) {
    logger.i(e);
  }
  return false;
}

saveDecryptTs(String savePath, var decrypted) {
  try {
    final file = File(savePath);
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(decrypted, flush: true);
    return true;
  } catch (e) {
    logger.i(e);
  }
  return false;
}
