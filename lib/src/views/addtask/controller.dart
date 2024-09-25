import 'package:famd/src/controller/task.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/utils/date/date_utils.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:famd/src/views/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddTaskController extends GetxController {
  final _taskCtrl = Get.find<TaskController>();
  final _homeCtrl = Get.find<HomeController>();
  final TextEditingController urlTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  late String downPath;
  @override
  void onReady() {
    super.onReady();
    // print("AddTaskController onReady");
    _init();
  }

  _init() async {
    downPath = await getDownPath();
  }

  addTask() async {
    if (urlTextController.text.isEmpty || nameTextController.text.isEmpty) {
      EasyLoading.showInfo(FamdLocale.addTaskInputUrlCantEmpty.tr);
      return;
    }
    List<String> urls = urlTextController.text.split('\n');
    for (String url in urls) {
      List<String> info = url.split('\$');
      if (info.length != 2) {
        EasyLoading.showInfo('$url${FamdLocale.linkError.tr}！');
        return;
      }
      if (!info[1].startsWith('http')) {
        EasyLoading.showInfo('${info[1]}${FamdLocale.linkErrorTip.tr}');
        return;
      }
      String m3u8name = '${nameTextController.text}-${info[0]}';
      bool has = await hasM3u8Name(
          nameTextController.text, info[0].replaceAll(" ", ""));
      if (has) {
        EasyLoading.showInfo('$m3u8name,${FamdLocale.alreadyInList.tr}');
        return;
      }
      M3u8Task task = M3u8Task(
          subname: info[0].replaceAll(" ", ""),
          m3u8url: info[1]
              .replaceAll(" ", "")
              .replaceAll("\r\n", "")
              .replaceAll("\r", "")
              .replaceAll("\n", ""),
          m3u8name: nameTextController.text.replaceAll(" ", ""),
          downdir: downPath,
          status: 1,
          createtime: now());
      await insertM3u8Task(task);
    }
    await _taskCtrl.updateTaskList();
    _homeCtrl.changePageView(1);
    urlTextController.clear();
    nameTextController.clear();
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    EasyLoading.showSuccess(FamdLocale.addSuccess.tr);
  }
}
