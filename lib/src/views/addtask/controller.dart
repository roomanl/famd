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
    String inputName = nameTextController.text.replaceAll(" ", "");
    String inputUrl = urlTextController.text.replaceAll(" ", "");
    List<String> urls = inputUrl.split('\n');
    int count = 0;
    for (String url in urls) {
      url =
          url.replaceAll("\r\n", "").replaceAll("\r", "").replaceAll("\n", "");
      count++;
      String m3u8name = '';
      String subName = '';
      String tsUrl = '';
      if (url.contains("\$")) {
        List<String> info = url.split('\$');
        if (info.length != 2) {
          EasyLoading.showInfo('$url${FamdLocale.linkError.tr}！');
          return;
        }
        subName = info[0];
        tsUrl = info[1];
      } else {
        subName = count.toString();
        tsUrl = url;
      }
      if (!tsUrl.startsWith('http')) {
        EasyLoading.showInfo('$tsUrl${FamdLocale.linkErrorTip.tr}');
        return;
      }
      m3u8name = '$inputName-$subName';
      bool has = await hasM3u8Name(inputName, subName);
      if (has) {
        EasyLoading.showInfo('$m3u8name,${FamdLocale.alreadyInList.tr}');
        return;
      }
      M3u8Task task = M3u8Task(
          subname: subName,
          m3u8url: tsUrl,
          m3u8name: inputName,
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
