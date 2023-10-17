import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

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

getDirFile(String dir) {
  Directory directory = Directory(dir);
  return directory.listSync();
}

getPlugAssetsDir(String plugName) {
  String pathSeparator = Platform.pathSeparator;
  if (kDebugMode) {}
  String plugDir = 'data${pathSeparator}plugin$pathSeparator$plugName';
  if (Platform.isWindows || Platform.isLinux) {
    String exePath = Platform.resolvedExecutable;
    List<String> pathList = exePath.split(pathSeparator);
    // String basename = path.basename(exePath);
    pathList[pathList.length - 1] = plugDir;
    return pathList.join(pathSeparator);
  }
  return null;
}

getAppRootDir() {
  return Directory.current.path;
}
