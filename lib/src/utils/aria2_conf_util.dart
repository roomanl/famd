import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../common/const.dart';
import 'file_utils.dart';
import 'native_channel_utils.dart';
import 'package:http/http.dart' as http;

getAria2rootPath() async {
  return await getPlugAssetsDir('aria2');
}

getAria2ExePath() async {
  if (Platform.isWindows || Platform.isLinux) {
    String dir = await getPlugAssetsDir('aria2');
    String ariaName = 'm3u8aria2c';
    if (Platform.isWindows) {
      ariaName = 'm3u8aria2c.exe';
    }
    return '$dir/$ariaName';
  } else if (Platform.isAndroid) {
    final libDir = await nativeLibraryDir();
    var libPath = '$libDir/libaria2c.so';
    File file = File(libPath);
    if (!file.existsSync()) {
      EasyLoading.showToast('aria2 没找到');
    }
    return libPath;
  }
}

Future<String> getAria2ConfPath() async {
  String dir = await getPlugAssetsDir('aria2');
  return '$dir${Platform.pathSeparator}aria2.conf';
}

Future<String> getAria2UrlConf() async {
  String port = await getAria2Port();
  return ARIA2_URL_VALUE.replaceAll('{port}', port);
}

initAria2Conf() async {
  String? trackerList;
  try {
    var res = await http.get(Uri.parse(ARIA2_Tracker_List));
    if (res.statusCode == 200) {
      trackerList = res.body;
    }
  } catch (e) {}
  String rootPath = await getAria2rootPath();
  String confPath = await getAria2ConfPath();
  List<String> aria2ConfLines = await readDefAria2Conf();
  List<String> confLines = [];
  String logFile = '$rootPath${Platform.pathSeparator}aria2.log';
  String sessionFile = '$rootPath${Platform.pathSeparator}aria2.session';
  String downloadsDir =
      await getAppRootDir() + '${Platform.pathSeparator}downloads';
  deleteFile(logFile);
  deleteFile(sessionFile);
  createDir(downloadsDir);
  createFile(logFile);
  createFile(sessionFile);
  confLines.add('dir=$downloadsDir');
  confLines.add('log=$logFile');
  confLines.add('input-file=$sessionFile');
  confLines.add('save-session=$sessionFile');
  for (String line in aria2ConfLines) {
    if (line.startsWith('bt-tracker') && trackerList != null) {
      confLines.add('bt-tracker=$trackerList');
    } else if (!line.startsWith('dir=') &&
        !line.startsWith('log=') &&
        !line.startsWith('input-file=') &&
        !line.startsWith('save-session=')) {
      confLines.add(line);
    }
  }
  writeLinesToFile(confPath, confLines.join("\n"));
}

getAria2Port() async {
  String confPath = await getAria2ConfPath();
  List<String> textLines = readFile(confPath);
  String port = '46800';
  for (String line in textLines) {
    if (line.startsWith('rpc-listen-port=')) {
      port = line.replaceAll('rpc-listen-port=', '');
      break;
    }
  }
  return port;
}

clearSession() async {
  String sessionFile =
      await getAria2rootPath() + '${Platform.pathSeparator}aria2.session';
  deleteFile(sessionFile);
  createFile(sessionFile);
}
