import 'package:flutter/services.dart';

const MethodChannel _channel =
    MethodChannel('cn.rootvip.flutter_native_channel/native_methods');

Future<String> nativeLibraryDir() async {
  return await _channel.invokeMethod('nativeLibraryDir');
}

Future<List<int>> decryptTS(String path, String key) async {
  return await _channel.invokeMethod('decryptTS', {'path': path, 'key': key});
}

playerAndroidVideo(String path) async {
  return await _channel.invokeMethod('playerVideo', {'path': path});
}

requestPermission() async {
  return await _channel.invokeMethod('requestPermission');
}
