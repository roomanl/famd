import 'dart:ui';

import 'package:famd/src/common/color.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<Color> mainColor = FamdColor.themeColors[0].color.obs;
  RxString mainFont = 'FangYuan2'.obs;
  RxBool isDarkMode = false.obs;

  @override
  void onReady() {
    super.onReady();
    debugPrint("ThemeController onReady");
  }

  init() async {
    FamdThemeColor themeColor = await getThemeColor();
    updateMainColor(themeColor.color);
    String darkMode = await getDarkMode();
    updateDarkMode(darkMode == '1' ? true : false);
  }

  updateMainColor(color) {
    mainColor.update((val) {
      if (isDarkMode.isTrue) {
        mainColor.value = FamdColor.colorDark;
      } else {
        mainColor.value = color;
      }
      changeTheme();
    });
  }

  updateDarkMode(bool darkMode) {
    isDarkMode.update((val) async {
      isDarkMode.value = darkMode;
      FamdThemeColor themeColor = await getThemeColor();
      updateMainColor(themeColor.color);
    });
  }

  changeTheme() {
    Get.changeTheme(
      ThemeData(
          useMaterial3: true,
          fontFamily: mainFont.value,
          colorSchemeSeed: mainColor.value,
          brightness: isDarkMode.value ? Brightness.dark : Brightness.light),
    );
  }
}
