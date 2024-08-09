import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:famd/src/utils/common_utils.dart';

class AppController extends GetxController with WidgetsBindingObserver {
  RxString appVersion = ''.obs;
  RxBool aria2Online = false.obs;
  RxInt aria2Speed = 0.obs;
  RxBool showNavigationDrawer = false.obs;

  @override
  void onReady() {
    super.onReady();
    print("AppController onReady");
    _init();
    changWinSize();
    updateAppVersion();
  }

  _init() async {}

  updateAppVersion() {
    appVersion.update((val) async {
      appVersion.value = await getAppVersion();
    });
  }

  updateAria2Online(bool online) {
    aria2Online.update((val) {
      aria2Online.value = online;
    });
  }

  updateAria2Speed(int speed) {
    aria2Speed.update((val) {
      aria2Speed.value = speed;
    });
  }

  updateShowNavigationDrawer(bool online) {
    showNavigationDrawer.update((val) {
      showNavigationDrawer.value = online;
    });
  }

  changWinSize() {
    updateShowNavigationDrawer(MediaQuery.of(Get.context!).size.width <= 500);
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    changWinSize();
    // print("didChangeMetrics");
  }
}
