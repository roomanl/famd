import 'package:famd/src/controller/app.dart';
import 'package:famd/src/controller/task.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AppController>(() => AppController());
    // Get.lazyPut<ThemeController>(() => ThemeController());
    Get.put(AppController());
    Get.put(TaskController());
  }
}
