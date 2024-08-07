import 'package:famd/src/controller/app.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/views/about/controller.dart';
import 'package:get/get.dart';

import 'controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AboutController>(() => AboutController());
    // Get.lazyPut<AppController>(() => AppController());
    // Get.lazyPut<ThemeController>(() => ThemeController());
  }
}
