import 'package:famd/src/utils/setting_conf_utils.dart';

import 'sys_conf.dart';

class SettingConf {
  late SysConf downPath = SysConf(name: 'downPath', value: '');

  initValue() async {
    String downPath = await getDownPath();
    this.downPath.value = downPath;
  }
}
