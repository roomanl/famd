import 'package:famd/src/common/color.dart';
import 'package:famd/src/common/keys.dart';
import 'package:famd/src/utils/setting_conf_utils.dart' as conf;

import 'sys_conf.dart';

class SettingConf {
  final SysConf downPath = SysConf(name: FamdConfKey.downPath, value: '');
  final SysConf themeColor = SysConf(name: FamdConfKey.themeColor, value: '');
  final SysConf darkMode = SysConf(name: FamdConfKey.darkMode, value: '');
  final SysConf retryInterval =
      SysConf(name: FamdConfKey.retryInterval, value: '');
  final SysConf maxDownTsNum =
      SysConf(name: FamdConfKey.maxDownTsNum, value: '');
  final SysConf maxDownThread =
      SysConf(name: FamdConfKey.maxDownThread, value: '');

  initValue() async {
    downPath.value = await conf.getDownPath();
    FamdThemeColor color = await conf.getThemeColor();
    themeColor.value = color.label;
    darkMode.value = await conf.getDarkMode();
    retryInterval.value = await conf.getRetryInterval();
    maxDownTsNum.value = await conf.getMaxDownTsNum();
    maxDownThread.value = await conf.getMaxDownThread();
  }
}
