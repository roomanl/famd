import 'dart:ui';
import 'package:get/state_manager.dart';

class CustomThemeController extends GetxController {
  Rx<Color> mainColor = const Color.fromRGBO(18, 161, 130, 1).obs;
  RxString mainFont = 'FangYuan2'.obs;
  changeMainColor(color) {
    mainColor = color;
    // mainColor.update((val) {
    //   print(val.toString());
    //   print(color.toString());
    //   val = color;
    //   print(val.toString());
    // });
  }

  changeMainFont(font) {
    mainFont = font;
    // mainFont.update((val) {
    //   val = font;
    // });
  }
}
