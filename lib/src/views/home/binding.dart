import 'package:famd/src/views/about/controller.dart';
import 'package:famd/src/views/addtask/controller.dart';
import 'package:famd/src/views/downmanager/controller.dart';
import 'package:famd/src/views/m3u8web/controller.dart';
import 'package:famd/src/views/setting/controller.dart';
import 'package:get/get.dart';

import 'controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<HomeController>(() => HomeController());
    // Get.lazyPut<AboutController>(() => AboutController());
    // Get.lazyPut<AddTaskController>(() => AddTaskController());
    // Get.lazyPut<DownManagerController>(() => DownManagerController());
    // Get.lazyPut<SettingController>(() => SettingController());
    Get.put(HomeController());
    Get.put(AddTaskController());
    Get.put(DownManagerController());
    Get.put(M3U8WebController());
    Get.put(SettingController());
    Get.put(AboutController());
  }
}
