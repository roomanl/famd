import 'dart:convert';
import 'package:famd/src/common/config.dart';
import 'package:famd/src/controller/app.dart';
import 'package:famd/src/utils/common_utils.dart';
import 'package:famd/src/utils/http/http.dart';
import 'package:get/get.dart';

class M3U8WebController extends GetxController {
  final _appCtrl = Get.find<AppController>();
  RxList resourceList = RxList();
  RxInt crossAxisCount = 3.obs;
  @override
  void onReady() {
    super.onReady();
    _appCtrl.winWidth.listen((val) {
      _updateCrossAxisCount(val);
    });
    _getResource();
  }

  openWeb(var item) {
    openWebUrl(item['url']);
  }

  _getResource() async {
    var res = await sslClient().get(Uri.parse(FamdConfig.m3u8ResourceUrl));
    final list = jsonDecode(utf8.decode(res.bodyBytes)) as List;
    _updateResourceList(list);
    // debugPrint(list.toString());
  }

  _updateCrossAxisCount(width) {
    if (_appCtrl.showNavigationDrawer.isFalse) {
      width = width - 60;
    }
    int count = width < 500 ? 2 : width ~/ 200;
    crossAxisCount.update((val) {
      crossAxisCount.value = count < 1 ? 1 : count;
    });
  }

  _updateResourceList(list) {
    resourceList.value = list;
    update();
  }
}
