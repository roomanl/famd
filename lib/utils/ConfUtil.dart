import 'package:shared_preferences/shared_preferences.dart';
import '../common/const.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<String?> getConf(String key) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString(key);
}

Future<bool> setConf(String key, String data) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString(key, data);
}

Future<String?> getAria2PathConf() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString(ARIA2_PATH);
}

Future<bool> setAria2PathConf(data) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString(ARIA2_PATH, data);
}

Future<String?> getFFmpegPathConf() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString(FFMPEG_PATH);
}

Future<bool> setFFmpegPathConf(data) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString(FFMPEG_PATH, data);
}

Future<String?> getDownPathConf() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString(DOWN_PATH);
}

Future<bool> setDownPathConf(data) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString(DOWN_PATH, data);
}

Future<String?> getAria2UrlConf() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString(ARIA2_URL);
}

Future<bool> setAria2UrlConf(data) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString(ARIA2_URL, data);
}
