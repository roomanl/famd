import 'package:famd/src/controller/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppVersion extends GetView<AppController> {
  const AppVersion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text(
        'V ${controller.appVersion}',
        style: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.3), fontSize: 18),
      ),
    );
  }
}
