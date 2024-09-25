import 'package:get/get.dart';

import 'controller.dart';

class M3U8wEBBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<M3U8WebController>(() => M3U8WebController());
  }
}
