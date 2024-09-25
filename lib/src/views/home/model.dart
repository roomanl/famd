import 'package:famd/src/common/config.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/router/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeftBarStyle {
  Color? textColor;
  Color? activeColor;
  TextStyle? labelStyle;

  LeftBarStyle({
    this.textColor = const Color(0xffcfd1d7),
    this.activeColor = const Color.fromRGBO(27, 167, 132, 1),
    this.labelStyle = const TextStyle(color: Color(0xffcfd1d7), fontSize: 11),
  });
}

enum NavType { viewPage, route, checkUpdate, outLink }

class NavDestination {
  const NavDestination({
    required this.label,
    required this.icon,
    this.type,
    this.route,
    this.pageIndex,
  });

  final String label;
  final String? route;
  final NavType? type;
  final int? pageIndex;
  final Widget icon;
}

class HomeMenu {
  static final List<NavDestination> leftTopMenu = <NavDestination>[
    NavDestination(
        label: FamdLocale.addTask.tr,
        icon: const Icon(Icons.add_circle_outline_rounded)),
    NavDestination(
        label: FamdLocale.taskManager.tr, icon: const Icon(Icons.home_rounded)),
    NavDestination(
        label: FamdLocale.find.tr, icon: const Icon(Icons.explore_rounded)),
    // NavDestination(
    //     label: FamdLocale.setting.tr, icon: const Icon(Icons.settings)),
    // NavDestination(label: FamdLocale.about.tr, icon: const Icon(Icons.info))
  ];

  static final List<NavDestination> leftMoreMenu = <NavDestination>[
    NavDestination(
        label: FamdLocale.discussion.tr,
        icon: const Icon(Icons.message),
        type: NavType.outLink,
        route: FamdConfig.discussionUrl),
    NavDestination(
        label: FamdLocale.setting.tr,
        icon: const Icon(Icons.settings),
        type: NavType.viewPage,
        pageIndex: 3),
    NavDestination(
        label: FamdLocale.about.tr,
        icon: const Icon(Icons.info),
        route: RouteNames.setting,
        type: NavType.viewPage,
        pageIndex: 4),
    NavDestination(
        label: FamdLocale.checkUpdate.tr,
        icon: const Icon(Icons.update_rounded),
        route: RouteNames.setting,
        type: NavType.checkUpdate),
  ];
}
