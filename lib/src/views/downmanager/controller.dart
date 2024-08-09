import 'package:famd/src/components/dialog/confirm_dialog.dart';
import 'package:famd/src/controller/task.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/models/task_info.dart';
import 'package:famd/src/utils/file/file_utils.dart';
import 'package:famd/src/utils/task/task_manager.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownManagerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _taskCtrl = Get.find<TaskController>();
  late final TabController tabController;
  final TaskManager _taskManager = TaskManager();
  TaskInfo taskInfo = TaskInfo();
  RxString downStatusInfo = "".obs;
  RxString aria2Notifications = "".obs;

  @override
  void onInit() {
    super.onInit();
    print("DownManagerController onInit");
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onReady() {
    super.onReady();
    print("DownManagerController onReady");
    _init();
  }

  _init() async {
    await _taskCtrl.updateTaskList();
    await _taskManager.resetTask(_taskCtrl.taskList);
  }

  startTask() {}
  resetTask() async {
    _taskManager.downFinish();
    await _taskManager.resetTask(_taskCtrl.taskList);
    await _taskCtrl.updateTaskList();
    startTask();
  }

  updateTaskInfo(info) {
    taskInfo = info;
    update();
  }

  updateDownStatusInfo(String info) {
    downStatusInfo.update((val) {
      downStatusInfo.value = info;
    });
  }

  updateAria2Notifications(String info) {
    aria2Notifications.update((val) {
      aria2Notifications.value = info;
    });
  }

  deleteTask(M3u8Task task, bool delFile) {
    showConfirmDialog(
      context: Get.context!,
      content: "确定要删除此任务以及本地文件吗？",
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
      content: "确定要删除所有任务以及本地文件吗？",
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
