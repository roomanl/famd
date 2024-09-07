import 'package:flutter/services.dart';

const MethodChannel _channel =
    MethodChannel('cn.rootvip.flutter_native_channel/native_methods');

Future<String> nativeLibraryDir() async {
  return await _channel.invokeMethod('nativeLibraryDir');
}

Future<List<int>> decryptTS(String path, Uint8List key, Uint8List iv) async {
  return await _channel
      .invokeMethod('decryptTS', {'path': path, 'key': key, 'iv': iv});
}

playerAndroidVideo(String path) async {
  return await _channel.invokeMethod('playerVideo', {'path': path});
}

requestPermission() async {
  return await _channel.invokeMethod('requestPermission');
}
