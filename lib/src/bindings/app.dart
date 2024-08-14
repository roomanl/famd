import 'package:famd/src/controller/app.dart';
import 'package:famd/src/controller/input_focus.dart';
import 'package:famd/src/controller/task.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/controller/win_title_bar.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(ThemeController());
    Get.put(TaskController());
    Get.lazyPut<WinTitleBarController>(() => WinTitleBarController());
    Get.lazyPut<InputFocusController>(() => InputFocusController());
  }
}
