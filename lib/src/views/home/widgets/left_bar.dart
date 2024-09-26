import 'package:famd/src/common/asset.dart';
import 'package:famd/src/common/config.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/views/home/controller.dart';
import 'package:famd/src/views/home/model.dart';
import 'package:famd/src/views/home/widgets/left_more.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

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
        destinations: HomeMenu.leftTopMenu.map(
          (NavDestination destination) {
            return NavigationRailDestination(
              label: Text(destination.label),
              icon: destination.icon,
            );
          },
        ).toList(),
        selectedIndex: controller.viewPageIndex.value,
        leading: DragToMoveArea(
          child: Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: IconButton(
              onPressed: () {
                controller.openWeb(FamdConfig.famdGithub);
              },
              icon: Image.asset(
                FamdAsset.logo2,
                width: 30,
                height: 30,
              ),
            ),
          ),
        ),
        trailing: const Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: LeftMoreWidget(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: WifiIconWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
