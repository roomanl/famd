import 'package:get/get.dart';

import 'controller.dart';

class AddTaskBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTaskController>(() => AddTaskController());
  }
}
