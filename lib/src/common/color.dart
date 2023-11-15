import 'dart:ui';

const Color KONGQUELAN = Color.fromRGBO(14, 176, 201, 1); //孔雀蓝
const Color SHANCHAHONG = Color.fromRGBO(237, 85, 106, 1); //山茶红
const Color FENLV = Color.fromRGBO(131, 203, 172, 1); //粉绿

const List<CustomThemeColor> themeColors = <CustomThemeColor>[
  CustomThemeColor("剑锋紫", Color.fromRGBO(62, 56, 65, 1)),
  CustomThemeColor("芥花紫", Color.fromRGBO(152, 54, 128, 1)),
  CustomThemeColor("玉红", Color.fromRGBO(192, 72, 81, 1)),
  CustomThemeColor("山茶红", Color.fromRGBO(237, 85, 106, 1)),
  CustomThemeColor("宝石蓝", Color.fromRGBO(36, 134, 185, 1)),
  CustomThemeColor("孔雀蓝", Color.fromRGBO(14, 176, 201, 1)),
  CustomThemeColor("铜绿", Color.fromRGBO(43, 174, 133, 1)),
  CustomThemeColor("孔雀绿", Color.fromRGBO(34, 148, 83, 1)),
  CustomThemeColor("燕羽灰", Color.fromRGBO(104, 94, 72, 1)),
  CustomThemeColor("河豚灰", Color.fromRGBO(57, 55, 51, 1)),
];

class CustomThemeColor {
  const CustomThemeColor(this.label, this.color);

  final String label;
  final Color color;
}
