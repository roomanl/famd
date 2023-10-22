import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../entity/m3u8_task.dart';

createDir(String dir) {
  Directory directory = Directory(dir);
  if (!directory.existsSync()) {
    directory.create(recursive: true);
  }
}

createFile(String path) {
  File file = File(path);
  file.createSync(recursive: true);
}

deleteFile(String path) {
  File file = File(path);
  if (file.existsSync()) {
    try {
      file.deleteSync(recursive: true);
    } catch (e) {}
  }
}

writeLinesToFile(String path, String text) {
  File file = File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  file.writeAsStringSync(text, flush: true);
}

deleteDir(String dir) {
  Directory directory = Directory(dir);
  if (directory.existsSync()) {
    try {
      directory.deleteSync(recursive: true);
    } catch (e) {}
  }
}

fileExistsSync(String path) {
  File file = File(path);
  return file.existsSync();
}

List<String> readFile(String path) {
  File file = File(path);
  return file.existsSync() ? file.readAsLinesSync() : [];
}

Future<List<String>> readDefAria2Conf() async {
  String text = await rootBundle.loadString("lib/resources/aria2.conf");
  return text.split('\n');
}

getDirFile(String dir) {
  Directory directory = Directory(dir);
  if (!directory.existsSync()) {
    return [];
  }
  return directory.listSync();
}

getPlugAssetsDir(String plugName) async {
  String pathSeparator = Platform.pathSeparator;
  if (Platform.isWindows || Platform.isLinux) {
    String plugDir = 'data${pathSeparator}plugin$pathSeparator$plugName';
    String exePath = Platform.resolvedExecutable;
    List<String> pathList = exePath.split(pathSeparator);
    // String basename = path.basename(exePath);
    pathList[pathList.length - 1] = plugDir;
    return pathList.join(pathSeparator);
  } else if (Platform.isAndroid) {
    Directory? cacheDir = await getExternalStorageDirectory();
    String plugDir = '${cacheDir?.path}$pathSeparator$plugName';
    createDir(plugDir);
    return plugDir;
  }
  return null;
}

getAppRootDir() async {
  if (Platform.isWindows || Platform.isLinux) {
    return Directory.current.path;
  } else if (Platform.isAndroid) {
    Directory? cacheDir = await getExternalStorageDirectory();
    return cacheDir?.path;
  }
}

String getTsSaveDir(M3u8Task task, String? downPath) {
  return getDtsDir(task, downPath, 'ts');
}

String getDtsSaveDir(M3u8Task task, String? downPath) {
  return getDtsDir(task, downPath, 'dts');
}

String getDtsDir(M3u8Task task, String? downPath, String dirname) {
  String saveDir = '$downPath/${task.m3u8name}/${task.subname}/$dirname';
  createDir(saveDir);
  return saveDir;
}

String getMp4Path(M3u8Task task, String? downPath) {
  String mp4Path =
      '$downPath/${task.m3u8name}/${task.m3u8name}-${task.subname}.mp4';
  return mp4Path;
}

String getTsListTxtPath(M3u8Task task, String? downPath) {
  String fileListPath = '$downPath/${task.m3u8name}/${task.subname}/file.ts';
  return fileListPath;
}
