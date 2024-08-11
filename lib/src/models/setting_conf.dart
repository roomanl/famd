import 'package:famd/src/common/color.dart';
import 'package:famd/src/common/keys.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';

import 'sys_conf.dart';

class SettingConf {
  final SysConf downPath = SysConf(name: FamdConfKey.downPath, value: '');
  final SysConf themeColor = SysConf(name: FamdConfKey.themeColor, value: '');
  final SysConf darkMode = SysConf(name: FamdConfKey.darkMode, value: '');

  initValue() async {
    downPath.value = await getDownPath();
    FamdThemeColor color = await getThemeColor();
    themeColor.value = color.label;
    darkMode.value = await getDarkMode();
  }
}
