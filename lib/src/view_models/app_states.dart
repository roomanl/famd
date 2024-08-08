import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../common/color.dart';
import '../models/m3u8_task.dart';
import '../models/task_info.dart';
import '../utils/task/task_utils.dart';

class CustomThemeController extends GetxController {
  Rx<Color> mainColor = themeColors[0].color.obs;
  String? mainFont = 'FangYuan2';
  updateMainColor(color) {
    mainColor.update((val) {
      mainColor.value = color;
    });
  }
}

class AppController2 extends GetxController {
  RxInt pageIndex = 1.obs;
  RxBool aria2Online = false.obs;
  RxBool showNavigationDrawer = false.obs;
  RxInt aria2Speed = 0.obs;

  // @override
  // void onInit() {
  //   // everAll([aria2Online], (callback) => print("everAll----$count"));
  //   super.onInit();
  // }

  updatePageIndex(int index) {
    pageIndex.update((val) {
      pageIndex.value = index;
      // updateAria2Online(true);
    });
  }

  updateAria2Online(bool online) {
    // print("==>" + online.toString());
    aria2Online.update((val) {
      aria2Online.value = online;
    });
  }

  updateAria2Speed(int speed) {
    aria2Speed.update((val) {
      aria2Speed.value = speed;
    });
  }

  updateShowNavigationDrawer(bool online) {
    showNavigationDrawer.update((val) {
      showNavigationDrawer.value = online;
    });
  }
}

class TaskController2 extends GetxController {
  List<M3u8Task> taskList = [];
  List<M3u8Task> finishTaskList = [];
  TaskInfo taskInfo = TaskInfo();
  RxString downStatusInfo = "".obs;
  RxString aria2Notifications = "".obs;

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

  updateAria2Notifications(String info) {
    aria2Notifications.update((val) {
      aria2Notifications.value = info;
    });
  }
}
