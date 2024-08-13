import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:famd/src/utils/common_utils.dart';
import 'package:logger/logger.dart';

class AppController extends GetxController with WidgetsBindingObserver {
  var logger = Logger();
  RxString appVersion = ''.obs;
  RxBool aria2Online = false.obs;
  RxInt aria2Speed = 0.obs;
  RxBool showNavigationDrawer = false.obs;

  @override
  void onReady() {
    super.onReady();
    debugPrint("AppController onReady");
    changWinSize();
    updateAppVersion();
  }

  updateAppVersion() {
    appVersion.update((val) async {
      String version = await getAppVersion();
      appVersion.value = 'V $version';
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
  void didChangeMetrics() {
    super.didChangeMetrics();
    changWinSize();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
