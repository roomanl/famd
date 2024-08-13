import 'package:famd/src/components/bar/darg_win_bar.dart';
import 'package:famd/src/controller/app.dart';
import 'package:famd/src/controller/win_title_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 自定义Text组件
class WinTitleBar extends GetView<WinTitleBarController> {
  final Widget child;
  final bool useThemeColor;
  final bool? autoHide;

  const WinTitleBar({
    super.key,
    required this.useThemeColor,
    this.autoHide = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      return child;
    } else {
      return Get.find<AppController>().showNavigationDrawer.isTrue && autoHide!
          ? child
          : Scaffold(
              appBar: DargWinBar(
                useThemeColor: useThemeColor,
              ),
              body: child,
            );
    }
  }
}
