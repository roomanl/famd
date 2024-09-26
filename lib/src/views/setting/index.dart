import 'package:famd/src/common/color.dart';
import 'package:famd/src/components/bar/title_bar.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/widgets.dart';
import 'controller.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    return WinTitleBar(
      useThemeColor: true,
      autoHide: false,
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: false,
            backgroundColor: themeCtrl.mainColor.value,
            leading: const BackButton(
              color: FamdColor.white, // 设置返回箭头的颜色
            ),
            title: Text(
              FamdLocale.setting.tr,
              style: const TextStyle(
                color: FamdColor.white,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(15),
            children: <Widget>[
              const ConfDownFolderWidget(),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: const Divider(thickness: 1, height: 1),
              ),
              const ConfThemeColorWidget(),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: const Divider(thickness: 1, height: 1),
              ),
              const ConfDarkMode(),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: const Divider(thickness: 1, height: 1),
              ),
              const ConfRetryInterval(),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: const Divider(thickness: 1, height: 1),
              ),
              const ConfDownThread(),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: const Divider(thickness: 1, height: 1),
              ),
              const ConfMaxDownNum(),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: const Divider(thickness: 1, height: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
