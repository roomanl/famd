import 'dart:io';

import 'package:famd/src/db/DBSysConf.dart';
import 'package:famd/src/entity/sys_conf.dart';
import '../common/color.dart';
import '../common/const.dart';
import 'file_utils.dart';

final DBSysConf dbSysConf = DBSysConf();

Future<List<SysConf>> getAllConf() async {
  return await dbSysConf.queryAll();
}

Future<String?> getConf(String key) async {
  SysConf? conf = await dbSysConf.queryFirstByName(key);
  return conf?.value;
}

Future<bool> setConf(String key, String data) async {
  SysConf conf = SysConf(
    name: key,
    value: data,
  );
  int result = await dbSysConf.insert(conf);
  return result > 0;
}

Future<String> getDownPath() async {
  SysConf? conf = await dbSysConf.queryFirstByName(SYS_CONF_KEY['downPath']!);
  if (conf == null) {
    return await getAria2DefDownPath();
  }
  return conf.value;
}

Future<bool> setDownPath(data) async {
  return await setConf(SYS_CONF_KEY['downPath']!, data);
}

getAria2DefDownPath() async {
  String downloadsDir =
      await getAppRootDir() + '${Platform.pathSeparator}downloads';
  return downloadsDir;
}

Future<CustomThemeColor> getThemeColor() async {
  SysConf? conf = await dbSysConf.queryFirstByName(SYS_CONF_KEY['themeColor']!);
  if (conf == null) {
    return themeColors[0];
  }
  int index = themeColors.indexWhere((element) => element.label == conf.value);
  if (index < 0) {
    return themeColors[0];
  }
  return themeColors[index];
}
