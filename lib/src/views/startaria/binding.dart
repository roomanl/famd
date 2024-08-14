import 'package:get/get.dart';

import 'controller.dart';

class StartAriaBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartAriaController>(() => StartAriaController());
  }
}
