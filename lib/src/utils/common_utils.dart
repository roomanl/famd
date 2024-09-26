import 'dart:io';
import 'dart:math';
import 'package:famd/src/locale/locale.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'file/file_utils.dart';
import 'native_channel_utils.dart';

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

getAppDeviceId() async {
  return await FlutterUdid.udid;
}

openWebUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

playerVideo(String path) {
  if (Platform.isWindows) {
    path = path.replaceAll("/", "\\");
    Process.runSync('start', [path], runInShell: true);
  } else if (Platform.isAndroid) {
    playerAndroidVideo(path);
  } else {
    EasyLoading.showToast(FamdLocale.developing.tr);
  }
}

writeCrashLog(String txt) async {
  String logsFile = await getAppRootDir() + '/logs/log.log';
  appendWriteLinesToFile(logsFile,
      "\r\n======================================${DateTime.now()}==================================\r\n");
  appendWriteLinesToFile(logsFile, txt);
}
