import '../entity/SysConfig.dart';
import '../DBUtil.dart';

addOrSave(String name, String value) async {
  SysConfig sysConfig = SysConfig(name: name, value: value);
  SysConfig? config = await DBUtil().sysConfigDao.findSysConfigByName(name);
  if (config == null) {
    await DBUtil().sysConfigDao.insertSysConfig(sysConfig);
  } else {
    await DBUtil().sysConfigDao.updateSysConfigByName(name, value);
  }
}

Future<String?> findSysConfigByName(String name) async {
  SysConfig? config = await DBUtil().sysConfigDao.findSysConfigByName(name);
  return config?.value;
}
