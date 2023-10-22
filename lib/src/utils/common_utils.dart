import 'dart:io';
import 'dart:math';

import 'package:package_info_plus/package_info_plus.dart';

bytesToSize(bytes) {
  if (bytes == 0) return '0 B';
  var k = 1024;
  var sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  var i = (log(bytes) / log(k)).floor();
  return (bytes / pow(k, i)).toStringAsFixed(2) + ' ' + sizes[i];
}

permission777(filePath) {
  Process.runSync('chmod', ['-R', '777', filePath]);
}

getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}
