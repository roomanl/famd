import 'package:get/get.dart';

import 'controller.dart';

class AboutBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutController>(() => AboutController());
  }
}
