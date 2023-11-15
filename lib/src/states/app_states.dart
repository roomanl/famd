import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../common/color.dart';
import '../entity/m3u8_task.dart';
import '../entity/task_info.dart';
import '../utils/task_prefs_util.dart';

class CustomThemeController extends GetxController {
  Rx<Color> mainColor = themeColors[0].color.obs;
  String? mainFont = 'FangYuan2';
  updateMainColor(color) {
    mainColor.update((val) {
      mainColor.value = color;
    });
  }
}

class AppController extends GetxController {
  RxInt pageIndex = 1.obs;
  RxBool aria2Online = false.obs;
  RxBool showNavigationDrawer = false.obs;

  // @override
  // void onInit() {
  //   // everAll([aria2Online], (callback) => print("everAll----$count"));
  //   super.onInit();
  // }

  updatePageIndex(int index) {
    pageIndex.update((val) {
      pageIndex.value = index;
    });
  }

  updateAria2Online(bool online) {
    aria2Online.update((val) {
      aria2Online.value = online;
    });
  }

  updateShowNavigationDrawer(bool online) {
    showNavigationDrawer.update((val) {
      showNavigationDrawer.value = online;
    });
  }
}

class TaskController extends GetxController {
  List<M3u8Task> taskList = [];
  List<M3u8Task> finishTaskList = [];
  TaskInfo taskInfo = TaskInfo();
  RxString downStatusInfo = "".obs;

  updateTaskList() async {
    List<M3u8Task> list = await getM3u8TaskList();
    taskList = [];
    finishTaskList = [];
    for (M3u8Task task in list) {
      if (task.status == 1 || task.status == 2) {
        taskList.add(task);
      } else {
        finishTaskList.add(task);
      }
      // taskList.add(task);
      // finishTaskList.add(task);
      // update();
    }
    update();
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
}
