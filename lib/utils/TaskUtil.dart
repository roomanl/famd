import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../common/const.dart';
import '../entity/M3u8Task.dart';
import 'Aria2Util.dart';
import 'EventBusUtil.dart';
import 'M3u8Util.dart';
import 'TaskPrefsUtil.dart';

restTask(List<M3u8Task> taskList) async {
  Aria2Util().aria2c.forcePauseAll();
  Aria2Util().aria2c.purgeDownloadResult();
  for (M3u8Task task in taskList) {
    if (task.status == 2) {
      task.status = 1;
      await updateM3u8Task(task);
    }
  }
}
