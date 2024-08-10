import 'package:get/get.dart';

import 'result_controller.dart';

class ResultVodBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultVodController>(() => ResultVodController());
  }
}
