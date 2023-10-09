import 'dart:io';
import '../common/const.dart';
import 'file_utils.dart';

getAria2rootPath() {
  return getPlugAssetsDir('aria2');
}

getAria2ExePath() {
  String dir = getPlugAssetsDir('aria2');
  return '$dir/m3u8aria2c.exe';
}

getAria2ConfPath() {
  String dir = getPlugAssetsDir('aria2');
  return '$dir/aria2.conf';
}

getAria2UrlConf() {
  String port = getAria2Port();
  return ARIA2_URL_VALUE.replaceAll('{port}', port);
}

initAria2Conf() {
  String confPath = getAria2ConfPath();
  List<String> textLines = readFile(confPath);
  List<String> confLines = [];
  String logFile = getAria2rootPath() + '/aria2.log';
  String sessionFile = getAria2rootPath() + '/aria2.session';
  String downloadsDir = getAppRootDir() + '/downloads';
  deleteFile(logFile);
  deleteFile(sessionFile);
  createDir(downloadsDir);
  createFile(logFile);
  createFile(sessionFile);
  confLines.add('dir=$downloadsDir');
  confLines.add('log=$logFile');
  confLines.add('input-file=$sessionFile');
  confLines.add('save-session=$sessionFile');
  for (String line in textLines) {
    if (!line.startsWith('dir=') &&
        !line.startsWith('log=') &&
        !line.startsWith('input-file=') &&
        !line.startsWith('save-session=')) {
      confLines.add(line);
    }
  }
  writeLinesToFile(confPath, confLines.join("\n"));
}

getAria2Port() {
  String confPath = getAria2ConfPath();
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

clearSession() {
  String sessionFile = getAria2rootPath() + '/aria2.session';
  deleteFile(sessionFile);
  createFile(sessionFile);
}
