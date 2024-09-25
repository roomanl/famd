import 'package:famd/src/utils/app_update.dart' as updateUtil;
import 'package:famd/src/utils/aria2/ariar2_http_utils.dart' as aria2;
import 'package:famd/src/utils/common_utils.dart';
import 'package:get/get.dart';

class AboutController extends GetxController {
  RxString aria2Version = ''.obs;
  @override
  void onReady() {
    super.onReady();
    getAria2Version();
  }

  checkAppUpdate() {
    updateUtil.checkAppUpdate(Get.context!, true);
  }

  openWeb(String url) {
    openWebUrl(url);
  }

  getAria2Version() async {
    String version = await aria2.getAria2Version();
    updateAria2Version(version);
  }

  updateAria2Version(String version) {
    aria2Version.update((val) {
      aria2Version.value = version;
    });
  }
}
