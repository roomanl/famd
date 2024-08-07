import 'package:famd/src/utils/app_update.dart' as updateUtil;
import 'package:get/get.dart';

class AboutController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  checkAppUpdate() {
    updateUtil.checkAppUpdate(Get.context!, true);
  }
}
