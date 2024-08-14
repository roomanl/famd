import 'package:famd/src/controller/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppVersion extends GetView<AppController> {
  const AppVersion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text(
        '${controller.appVersion}',
        style: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.3), fontSize: 18),
      ),
    );
  }
}
