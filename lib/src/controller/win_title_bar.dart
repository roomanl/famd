import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';

class WinTitleBarController extends GetxController with WindowListener {
  final appCtrl = Get.find<AppController>();
  RxBool isMaximized = false.obs;
  @override
  void onReady() {
    debugPrint('WinTitleBarController onReady');
    windowManager.addListener(this);
    // _init();
  }

  // _init() async {
  //   bool isMaximized = await windowManager.isMaximized();
  //   updateIsMaximized(isMaximized);
  // }

  maximize() async {
    if (isMaximized.isFalse) {
      windowManager.maximize();
    } else {
      windowManager.unmaximize();
    }
    updateIsMaximized(!isMaximized.value);
  }

  minimize() {
    windowManager.minimize();
  }

  close() {
    windowManager.close();
  }

  @override
  onWindowMaximize() {
    updateIsMaximized(true);
    changWinSize();
  }

  @override
  onWindowUnmaximize() {
    updateIsMaximized(false);
    changWinSize();
  }

  updateIsMaximized(bool isMaximized) {
    this.isMaximized.update((value) {
      this.isMaximized.value = isMaximized;
    });
  }

  changWinSize() {
    Future.delayed(const Duration(milliseconds: 100), () {
      appCtrl.changWinSize();
    });
  }

  @override
  void onClose() {
    windowManager.removeListener(this);
    super.onClose();
  }
}
