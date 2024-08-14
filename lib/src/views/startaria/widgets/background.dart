import 'package:famd/src/controller/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundWidget extends GetView<ThemeController> {
  final Widget? child;
  const BackgroundWidget({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) {
        return Obx(
          () => Container(
            width: double.infinity,
            height: double.infinity,
            color: controller.mainColor.value,
            child: child,
          ),
        );
      },
    );
  }
}
