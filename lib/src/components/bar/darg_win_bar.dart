import 'package:famd/src/common/asset.dart';
import 'package:famd/src/common/color.dart';
import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/controller/win_title_bar.dart';
import 'package:famd/src/locale/locale.dart';
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
          // title: useThemeColor
          //     ? Row(
          //         children: <Widget>[
          //           SizedBox(
          //             width: 30,
          //             height: 20,
          //             child:
          //                 Image.asset(FamdAsset.logo2, width: 20, height: 20),
          //           ),
          //           TextInfo(
          //             text: FamdLocale.appName.tr + FamdLocale.channelName.tr,
          //             color: FamdColor.white,
          //           ),
          //         ],
          //       )
          //     : null,
          actions: <Widget>[
            SizedBox(
              width: 50,
              height: 30,
              child: IconButton(
                icon: _buildIcon(Icons.remove),
                onPressed: () => controller.minimize(),
              ),
            ),
            SizedBox(
              width: 50,
              height: 30,
              child: IconButton(
                icon: controller.isMaximized.value
                    ? _buildIcon(Icons.filter_none)
                    : _buildIcon(Icons.crop_free),
                onPressed: () => controller.maximize(),
              ),
            ),
            SizedBox(
              width: 50,
              height: 30,
              child: IconButton(
                icon: _buildIcon(Icons.close),
                onPressed: () => controller.close(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildIcon(IconData? icon) {
    return Icon(
      icon,
      size: 15,
      color: useThemeColor ? FamdColor.white : FamdColor.colorHTH,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(30);
}
