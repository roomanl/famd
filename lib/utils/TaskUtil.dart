import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../DB/server/SysConfigServer.dart';
import '../DB/server/M3u8TaskServer.dart';
import '../DB/entity/M3u8Task.dart';
import '../common/const.dart';
import 'Aria2Util.dart';
import 'EventBusUtil.dart';
import 'M3u8Util.dart';

restTask(List<M3u8Task> taskList) {
  Aria2Util().aria2c.forcePauseAll();
  Aria2Util().aria2c.purgeDownloadResult();
  for (M3u8Task task in taskList) {
    if (task.status == 2) {
      task.status = 1;
      updateM3u8Task(task);
    }
  }
}
