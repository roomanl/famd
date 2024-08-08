import 'package:get/get.dart';

import 'controller.dart';

class DownManagerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DownManagerController>(() => DownManagerController());
  }
}
