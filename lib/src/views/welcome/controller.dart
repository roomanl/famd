import 'package:famd/src/controller/task.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/utils/aria2/aria2_manager.dart';
import 'package:famd/src/utils/db/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _themeCtrl = Get.find<ThemeController>();
  final _taskCtrl = Get.find<TaskController>();
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(reverse: true);
    scaleAnimation =
        Tween<double>(begin: 0.8, end: 1.5).animate(animationController)
          ..addStatusListener((status) {
            if (status.toString() == 'AnimationStatus.reverse') {}
          });
    opacityAnimation =
        Tween<double>(begin: 0.1, end: 1.0).animate(animationController);
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint("WelcomeController onReady");

    _init();
  }

  _init() async {
    await DBHelper.getInstance().database;
    await _themeCtrl.init();
    _taskCtrl.init();
    Aria2Manager().init();
    Future.delayed(const Duration(milliseconds: 2000), () {
      Get.offNamed('/startaria');
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
