import 'package:flutter/services.dart';

const MethodChannel _channel =
    const MethodChannel('cn.rootvip.flutter_native_channel/native_methods');

getAria2SoPath() async {
  return await _channel.invokeMethod('getAria2SoPath');
}
