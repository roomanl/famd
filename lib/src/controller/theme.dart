import 'dart:ui';

import 'package:famd/src/common/color.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<Color> mainColor = themeColors[0].color.obs;
  RxString mainFont = 'FangYuan2'.obs;
  updateMainColor(color) {
    mainColor.update((val) {
      mainColor.value = color;
    });
  }

  @override
  void onReady() {
    super.onReady();
    print("ThemeController onReady");
  }
}
