import 'package:famd/src/common/color.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/home/controller.dart';
import 'package:famd/src/views/home/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeftMoreWidget extends GetView<HomeController> {
  const LeftMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<NavDestination>(
      icon: const Icon(Icons.tune_rounded),
      iconColor: FamdColor.white,
      tooltip: FamdLocale.more.tr,
      offset: const Offset(60, 0),
      onSelected: (NavDestination item) {
        controller.onMoreMenuSelected(item);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<NavDestination>>[
        ...HomeMenu.leftMoreMenu.map(
          (NavDestination destination) {
            return PopupMenuItem<NavDestination>(
              value: destination,
              child: ListTile(
                leading: destination.icon,
                title: Text(destination.label),
              ),
            );
          },
        ),
      ],
    );
  }
}
