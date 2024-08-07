import 'package:famd/src/controller/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundWidget extends GetView<ThemeController> {
  final Widget? child;
  const BackgroundWidget({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: controller.mainColor.value,
      child: child,
    );
  }
}
