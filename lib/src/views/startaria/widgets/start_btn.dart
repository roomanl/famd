import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/views/startaria/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartBtnWidget extends GetView<StartAriaController> {
  const StartBtnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    return Obx(
      () => ElevatedButton(
        style: ButtonStyle(
            padding: WidgetStateProperty.all(
              const EdgeInsets.all(20.0),
            ),
            backgroundColor: WidgetStateProperty.all(themeCtrl.mainColor.value),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            elevation: WidgetStateProperty.all(20),
            shape: WidgetStateProperty.all(
              const CircleBorder(),
            )),
        onPressed: () {
          controller.startAria2();
        },
        child: Obx(
          () => Text(
            '${controller.startBtnText}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
