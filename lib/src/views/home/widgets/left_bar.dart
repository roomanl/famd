import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/views/home/controller.dart';
import 'package:famd/src/views/home/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'wifi_icon.dart';

class HomeLeftBarWidget extends GetView<HomeController> {
  const HomeLeftBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    return Obx(
      () => NavigationRail(
        labelType: NavigationRailLabelType.none,
        backgroundColor: themeCtrl.mainColor.value,
        unselectedIconTheme:
            IconThemeData(color: controller.leftBarStyle.textColor),
        selectedIconTheme:
            IconThemeData(color: controller.leftBarStyle.activeColor),
        unselectedLabelTextStyle: controller.leftBarStyle.labelStyle,
        selectedLabelTextStyle: controller.leftBarStyle.labelStyle,
        onDestinationSelected: controller.handleScreenChanged,
        destinations: controller.destinations.map(
          (NavDestination destination) {
            return NavigationRailDestination(
              label: Text(destination.label),
              icon: destination.icon,
            );
          },
        ).toList(),
        selectedIndex: controller.viewPageIndex.value,
        trailing: const Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: WifiIconWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
