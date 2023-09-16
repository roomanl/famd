import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../DB/server/SysConfigServer.dart';
import '../DB/server/M3u8TaskServer.dart';
import '../DB/entity/M3u8Task.dart';
import '../common/const.dart';
import 'Aria2Util.dart';
import 'EventBusUtil.dart';
import 'M3u8Util.dart';

startAria2Task(M3u8Task task) async {
  EasyLoading.show(status: '正在开始任务...');
  String? downPath = await findSysConfigByName(DOWN_PATH);
  M3u8Util m3u8 = M3u8Util(m3u8url: task.m3u8url);
  await m3u8.init();
  task.iv = m3u8.IV;
  task.keyurl = m3u8.keyUrl;
  task.downdir = downPath;
  task.status = 2;

  List<String> tsList = m3u8.tsList;
  String saveDir = getTsSaveDir(task, downPath);
  await Aria2Util().addUrls(tsList, saveDir);
  updateM3u8Task(task);
  EasyLoading.showSuccess('任务启动成功');
}

String getTsSaveDir(M3u8Task task, String? downPath) {
  // String? downPath = await findSysConfigByName(DOWN_PATH);
  String saveDir = '$downPath/${task.m3u8name}/${task.subname}/ts';
  File file = File(saveDir);
  if (!file.existsSync()) {
    Directory(saveDir).create();
  }
  return saveDir;
}
