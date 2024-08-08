import 'package:famd/src/controller/task.dart';
import 'package:famd/src/models/m3u8_task.dart';
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

  deleteTask(M3u8Task task, bool delFile) {
    Get.defaultDialog(
      title: "提示",
      middleText: "确定要删除此任务以及本地文件吗？",
      onConfirm: () async {
        await deleteM3u8Task(task);
        if (delFile) {
          String mp4Path = taskFullMp4Path(task);
          String tsPath = taskFullTsDir(task);
          deleteFile(mp4Path);
          deleteDir(tsPath);
        }
        await _taskCtrl.updateTaskList();
        Get.back();
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  deleteAllTask() {}

  getTaskLength() {
    print(_taskCtrl.taskList.length);
    return _taskCtrl.taskList.length;
  }

  getTask(index) {
    return _taskCtrl.taskList[index];
  }

  getTaskStatus(index) {
    return _taskCtrl.taskList[index].status;
  }
}
