import 'dart:ui';

import 'package:famd/src/common/color.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<Color> mainColor = themeColors[0].color.obs;
  RxString mainFont = 'FangYuan2'.obs;

  @override
  void onReady() {
    super.onReady();
    print("ThemeController onReady");
  }

  init() async {
    CustomThemeColor themeColor = await getThemeColor();
    updateMainColor(themeColor.color);
  }

  updateMainColor(color) {
    mainColor.update((val) {
      mainColor.value = color;
      changeTheme();
    });
  }

  changeTheme() {
    Get.changeTheme(
      ThemeData(
          useMaterial3: true,
          fontFamily: mainFont.value,
          colorSchemeSeed: mainColor.value),
    );
  }
}
