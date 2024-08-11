import 'package:famd/src/components/dialog/confirm_dialog.dart';
import 'package:famd/src/controller/task.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/utils/file/file_utils.dart';
import 'package:famd/src/utils/task/task_manager.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:famd/src/utils/common_utils.dart' as common;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownManagerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _taskCtrl = Get.find<TaskController>();
  late final TabController tabController;
  final TaskManager _taskManager = TaskManager();

  @override
  void onInit() {
    super.onInit();
    debugPrint("DownManagerController onInit");
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint("DownManagerController onReady");
    _init();
  }

  _init() async {
    await _taskCtrl.updateTaskList();
    await _taskManager.resetTask(_taskCtrl.taskList);
  }

  startTask() {
    _taskManager.startAria2Task();
  }

  resetTask() async {
    _taskManager.downFinish();
    await _taskManager.resetTask(_taskCtrl.taskList);
    await _taskCtrl.updateTaskList();
    startTask();
  }

  resetFailTask(id) {
    _taskManager.resetFailTask(id);
  }

  playerVideo(M3u8Task task) {
    String mp4Path = getMp4Path(task, task.downdir);
    common.playerVideo(mp4Path);
  }

  deleteTask(M3u8Task task, bool delFile) {
    showConfirmDialog(
      context: Get.context!,
      content: FamdLocale.deleTaskTip.tr,
      onConfirm: () async {
        await deleteM3u8Task(task);
        if (delFile) {
          String mp4Path = taskFullMp4Path(task);
          String tsPath = taskFullTsDir(task);
          deleteFile(mp4Path);
          deleteDir(tsPath);
        }
        await _taskCtrl.updateTaskList();
        Navigator.of(Get.context!).pop();
      },
      onCancel: () {
        Navigator.of(Get.context!).pop();
      },
    );
  }

  deleteAllTask() {
    showConfirmDialog(
      context: Get.context!,
      content: FamdLocale.deleAllTaskTip.tr,
      onConfirm: () async {
        await _taskManager.resetTask(_taskCtrl.taskList);
        await clearM3u8Task();
        _taskCtrl.updateTaskList();
        Navigator.of(Get.context!).pop();
      },
      onCancel: () {
        Navigator.of(Get.context!).pop();
      },
    );
  }
}
