import 'package:famd/src/components/bar/title_bar.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/home/controller.dart';
import 'package:famd/src/views/home/widgets/wifi_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBarWidget extends GetView<HomeController>
    implements PreferredSizeWidget {
  const TopBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    return WinTitleBar(
      useThemeColor: true,
      autoHide: false,
      child: Obx(
        () => AppBar(
          backgroundColor: themeCtrl.mainColor.value,
          title: Text(
            FamdLocale.appNameAs.tr,
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
          leading: IconButton(
            color: const Color.fromRGBO(255, 255, 255, 1),
            icon: const Icon(Icons.home_rounded),
            onPressed: () => controller.changePageView(1),
          ),
          actions: <Widget>[
            const SizedBox(
              width: 50,
              child: WifiIconWidget(),
            ),
            SizedBox(
              width: 50,
              child: IconButton(
                color: const Color.fromRGBO(255, 255, 255, 1),
                icon: const Icon(Icons.add_circle_outline_rounded),
                onPressed: () => controller.changePageView(0),
              ),
            ),
            SizedBox(
              width: 50,
              child: IconButton(
                color: const Color.fromRGBO(255, 255, 255, 1),
                icon: const Icon(Icons.explore_rounded),
                onPressed: () => controller.openM3u8ResourcePage(),
              ),
            ),
            SizedBox(
              width: 50,
              child: IconButton(
                color: const Color.fromRGBO(255, 255, 255, 1),
                icon: const Icon(Icons.tune_rounded),
                onPressed: () => controller.openEndDrawer(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30);
}
