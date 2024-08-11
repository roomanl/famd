import 'dart:ui';

import 'package:famd/src/locale/locale.dart';
import 'package:get/get.dart';

class FamdColor {
  static const colorJFZ = Color.fromRGBO(62, 56, 65, 1);
  static const colorJHZ = Color.fromRGBO(152, 54, 128, 1);
  static const colorYH = Color.fromRGBO(192, 72, 81, 1);
  static const colorSCH = Color.fromRGBO(237, 85, 106, 1);
  static const colorBSL = Color.fromRGBO(36, 134, 185, 1);
  static const colorKQL = Color.fromRGBO(14, 176, 201, 1);
  static const colorTL = Color.fromRGBO(43, 174, 133, 1);
  static const colorKQLV = Color.fromRGBO(34, 148, 83, 1);
  static const colorYYH = Color.fromRGBO(104, 94, 72, 1);
  static const colorHTH = Color.fromRGBO(57, 55, 51, 1);
  static const colorFLV = Color.fromRGBO(131, 203, 172, 1);
  static const colorDark = Color.fromRGBO(0, 0, 0, 0.1);

  static List<FamdThemeColor> themeColors = <FamdThemeColor>[
    FamdThemeColor(FamdLocale.colorJFZ.tr, colorJFZ),
    FamdThemeColor(FamdLocale.colorJHZ.tr, colorJHZ),
    FamdThemeColor(FamdLocale.colorYH.tr, colorYH),
    FamdThemeColor(FamdLocale.colorSCH.tr, colorSCH),
    FamdThemeColor(FamdLocale.colorBSL.tr, colorBSL),
    FamdThemeColor(FamdLocale.colorKQL.tr, colorKQL),
    FamdThemeColor(FamdLocale.colorTL.tr, colorTL),
    FamdThemeColor(FamdLocale.colorKQLV.tr, colorKQLV),
    FamdThemeColor(FamdLocale.colorYYH.tr, colorYYH),
    FamdThemeColor(FamdLocale.colorHTH.tr, colorHTH),
  ];
}

class FamdThemeColor {
  const FamdThemeColor(this.label, this.color);
  final String label;
  final Color color;
}
