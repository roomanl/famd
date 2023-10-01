import 'package:shared_preferences/shared_preferences.dart';
import '../common/const.dart';
import 'FileUtils.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<String?> getConf(String key) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString(key);
}

Future<bool> setConf(String key, String data) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString(key, data);
}

Future<String> getDownPath() async {
  final SharedPreferences prefs = await _prefs;
  String? path = prefs.getString(SETTING_DOWN_PATH_KEY);
  return path ?? getAria2DefDownPath();
}

Future<bool> setDownPath(data) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString(SETTING_DOWN_PATH_KEY, data);
}

getAria2DefDownPath() {
  String downloadsDir = getAppRootDir() + '/downloads';
  return downloadsDir;
}
