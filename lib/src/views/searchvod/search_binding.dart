import 'package:get/get.dart';

import 'search_controller.dart';

class SearchVodBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchVodController>(() => SearchVodController());
  }
}
