import 'package:famd/src/controller/app.dart';
import 'package:famd/src/views/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WifiIconWidget extends GetView<HomeController> {
  const WifiIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appCtrl = Get.find<AppController>();
    return IconButton(
      icon: Obx(
        () => appCtrl.aria2Online.isTrue
            ? Image.asset('lib/resources/images/online.png',
                width: 25, height: 25)
            : Image.asset('lib/resources/images/offline.png',
                width: 25, height: 25),
      ),
      onPressed: () => controller.startAria2(),
    );
  }
}
