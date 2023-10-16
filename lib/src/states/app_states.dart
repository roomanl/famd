import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../entity/m3u8_task.dart';
import '../entity/task_info.dart';
import '../utils/task_prefs_util.dart';

class CustomTheme extends ChangeNotifier {
  Color mainColor = const Color.fromRGBO(18, 161, 130, 1);
  String mainFont = 'FangYuan2';
  changeMainColor(color) {
    mainColor = color;
    notifyListeners();
  }

  changeMainFont(font) {
    mainFont = font;
    notifyListeners();
  }
}

class AppController extends GetxController {
  RxInt pageIndex = 1.obs;
  RxBool aria2Online = false.obs;

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
}

class TaskController extends GetxController {
  List<M3u8Task> taskList = [];
  List<M3u8Task> finishTaskList = [];
  TaskInfo taskInfo = TaskInfo();

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
      // update();
    }
    update();
  }

  updateTaskInfo(info) {
    taskInfo = info;
    update();
  }
}
