import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/models/task_info.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  RxList<M3u8Task> taskList = RxList();
  RxList<M3u8Task> finishTaskList = RxList();
  RxString downStatusInfo = "".obs;
  RxString aria2Notifications = "".obs;
  Rx<TaskInfo> taskInfo = TaskInfo().obs;
  @override
  void onReady() {
    super.onReady();
    // debugPrint("TaskController onReady");
  }

  init() {
    updateTaskList();
  }

  updateTaskList() async {
    List<M3u8Task> list = await getM3u8TaskList();
    taskList = RxList();
    finishTaskList = RxList();
    for (M3u8Task task in list) {
      if (task.status == 1 || task.status == 2) {
        taskList.add(task);
      } else {
        finishTaskList.add(task);
      }
    }
    update();
  }

  updateTaskInfo(info) {
    taskInfo.update((val) {
      taskInfo.value = info;
    });
    // update();
  }

  updateDownStatusInfo(String info) {
    downStatusInfo.update((val) {
      debugPrint(info);
      downStatusInfo.value = info;
    });
  }

  updateAria2Notifications(String info) {
    aria2Notifications.update((val) {
      aria2Notifications.value = info;
    });
  }
}
