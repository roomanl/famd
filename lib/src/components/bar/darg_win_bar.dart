import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/controller/win_title_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class DargWinBar extends GetView<WinTitleBarController>
    implements PreferredSizeWidget {
  final bool useThemeColor;
  const DargWinBar({
    super.key,
    required this.useThemeColor,
  });
  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    return Obx(
      () => DragToMoveArea(
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: useThemeColor ? themeCtrl.mainColor.value : null,
          toolbarHeight: 30,
          // title: DragToMoveArea(
          //   child: Row(
          //     children: <Widget>[
          //       SizedBox(
          //         width: 30,
          //         height: 20,
          //         child: Image.asset('lib/resources/images/logo.png',
          //             width: 20, height: 20),
          //       ),
          //       Text(
          //         FamdLocale.appName.tr + FamdLocale.channelName.tr,
          //         style: const TextStyle(fontSize: 15),
          //       ),
          //     ],
          //   ),
          // ),
          actions: <Widget>[
            SizedBox(
              width: 50,
              height: 30,
              child: IconButton(
                icon: const Icon(Icons.remove, size: 15),
                onPressed: () => controller.minimize(),
              ),
            ),
            SizedBox(
              width: 50,
              height: 30,
              child: IconButton(
                icon: controller.isMaximized.value
                    ? const Icon(Icons.filter_none, size: 15)
                    : const Icon(Icons.crop_free, size: 15),
                onPressed: () => controller.maximize(),
              ),
            ),
            SizedBox(
              width: 50,
              height: 30,
              child: IconButton(
                icon: const Icon(Icons.close, size: 15),
                onPressed: () => controller.close(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(30);
}
