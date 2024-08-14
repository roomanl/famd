import 'package:famd/src/components/app_title.dart';
import 'package:famd/src/components/app_version.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class WelcomPage extends GetView<WelcomeController> {
  const WelcomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          backgroundColor: Get.find<ThemeController>().mainColor.value,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: AppTileWidget(),
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: controller.animationController,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.scale(
                        scale: controller.scaleAnimation.value,
                        child: Opacity(
                          opacity: controller.opacityAnimation.value,
                          child: Image.asset(
                            'lib/resources/images/logo.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AppVersion(),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
