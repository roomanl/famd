import 'package:famd/src/common/color.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';

import 'sys_conf.dart';

class SettingConf {
  final SysConf downPath = SysConf(name: 'downPath', value: '');
  final SysConf themeColor = SysConf(name: 'themeColor', value: '');

  initValue() async {
    downPath.value = await getDownPath();
    CustomThemeColor color = await getThemeColor();
    themeColor.value = color.label;
  }
}
