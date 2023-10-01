import 'dart:io';
import 'package:flutter/foundation.dart';

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
  file.writeAsString(text, flush: true);
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

getPlugAssetsDir(String plugName) {
  String osDirName = '';
  String assetsDirName = '';
  if (Platform.isWindows) {
    osDirName = 'windows';
  }
  if (kDebugMode) {
    assetsDirName = 'plugin';
  } else {
    assetsDirName = 'data/flutter_assets/plugin';
  }
  String dir = '${Directory.current.path}/$assetsDirName/$osDirName/$plugName';
  return dir;
}

getAppRootDir() {
  return Directory.current.path;
}
