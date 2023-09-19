import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:logger/logger.dart';
import "package:pointycastle/export.dart";

var logger = Logger();

bool aseDecryptTs(
    String tsPath, String savePath, String keystr, String? ivstr) {
  ivstr ??= '0x00000000000000000000000000000000';
  try {
    File tsfile = File(tsPath);
    final bytes = tsfile.readAsBytesSync();

    final key = Uint8List.fromList(keystr.codeUnits);
    // final iv = Uint8List.fromList(ivstr.substring(0, 16).codeUnits);
    final iv = IV.fromLength(16).bytes;
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
    final decrypted = paddingCipher.process(bytes);
    final file = File(savePath);
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(decrypted, flush: true);

    return true;
  } catch (e) {
    logger.i(e);
  }
  return false;
}
