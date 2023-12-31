import 'package:shared_preferences/shared_preferences.dart';
import '../common/color.dart';
import '../common/const.dart';
import 'file_utils.dart';

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
  return path ?? await getAria2DefDownPath();
}

Future<bool> setDownPath(data) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString(SETTING_DOWN_PATH_KEY, data);
}

getAria2DefDownPath() async {
  String downloadsDir = await getAppRootDir() + '/downloads';
  return downloadsDir;
}

Future<CustomThemeColor> getThemeColor() async {
  final SharedPreferences prefs = await _prefs;
  String? label = prefs.getString(SETTING_THEME_COLOR_KEY);
  int index = themeColors.indexWhere((element) => element.label == label);
  if (index < 0) {
    return themeColors[0];
  }
  return themeColors[index];
}
