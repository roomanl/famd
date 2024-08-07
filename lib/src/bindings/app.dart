import 'package:famd/src/controller/app.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppController>(() => AppController());
    Get.lazyPut<ThemeController>(() => ThemeController());
  }
}
