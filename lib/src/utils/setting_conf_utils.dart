import 'dart:io';

import 'package:famd/src/common/keys.dart';
import 'package:famd/src/utils/db/DBSysConf.dart';
import 'package:famd/src/models/sys_conf.dart';
import '../common/color.dart';
import 'file/file_utils.dart';

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
  SysConf? conf = await dbSysConf.queryFirstByName(FamdConfKey.downPath);
  if (conf == null) {
    return await getAria2DefDownPath();
  }
  return conf.value;
}

Future<bool> setDownPath(data) async {
  return await setConf(FamdConfKey.downPath, data);
}

getAria2DefDownPath() async {
  String downloadsDir =
      await getAppRootDir() + '${Platform.pathSeparator}downloads';
  return downloadsDir;
}

Future<FamdThemeColor> getThemeColor() async {
  SysConf? conf = await dbSysConf.queryFirstByName(FamdConfKey.themeColor);
  if (conf == null) {
    return FamdColor.themeColors[0];
  }
  int index = FamdColor.themeColors
      .indexWhere((element) => element.label == conf.value);
  if (index < 0) {
    return FamdColor.themeColors[0];
  }
  return FamdColor.themeColors[index];
}

Future<String> getDarkMode() async {
  SysConf? conf = await dbSysConf.queryFirstByName(FamdConfKey.darkMode);
  if (conf == null) {
    return '0';
  }
  return conf.value;
}

Future<String> getRetryInterval() async {
  SysConf? conf = await dbSysConf.queryFirstByName(FamdConfKey.retryInterval);
  if (conf == null) {
    return '30';
  }
  return conf.value;
}

Future<String> getMaxDownTsNum() async {
  SysConf? conf = await dbSysConf.queryFirstByName(FamdConfKey.maxDownTsNum);
  if (conf == null) {
    return '32';
  }
  return conf.value;
}

Future<String> getMaxDownThread() async {
  SysConf? conf = await dbSysConf.queryFirstByName(FamdConfKey.maxDownThread);
  if (conf == null || int.parse(conf.value) > 16) {
    return '16';
  }
  return conf.value;
}

Future<String> getAria2Port() async {
  SysConf? conf = await dbSysConf.queryFirstByName(FamdConfKey.aria2Port);
  if (conf == null) {
    return '46800';
  }
  return conf.value;
}
