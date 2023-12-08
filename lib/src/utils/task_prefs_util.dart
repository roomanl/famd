import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/m3u8_task.dart';

final logger = Logger();

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

final prefsKey = 'm3u8_task_data';

/**
 * 获取任务列表
 */
Future<List<M3u8Task>> getM3u8TaskList() async {
  final SharedPreferences prefs = await _prefs;
  List<String>? list = prefs.getStringList(prefsKey);
  if (list == null) {
    return [];
  }
  List<M3u8Task> taskList = [];
  for (String item in list) {
    // final map = jsonDecode(jsonDecode(item));
    // logger.i(item);
    taskList.add(M3u8Task.fromJson(item));
  }
  // logger.i(taskList.toString());
  return taskList;
}

/**
 * 更新任务列表
 */
Future<bool> updateM3u8TaskList(List<M3u8Task> list) async {
  final SharedPreferences prefs = await _prefs;
  List<String> strList = [];
  if (list.length > 0) {
    for (M3u8Task task in list) {
      strList.add(task.toJson());
    }
  }
  return prefs.setStringList(prefsKey, strList);
}

/**
 * 插入任务
 */
Future<bool> insertM3u8Task(M3u8Task task) async {
  final SharedPreferences prefs = await _prefs;
  List<M3u8Task> taskList = await getM3u8TaskList();
  taskList.add(task);
  List<String> strList = [];
  for (M3u8Task item in taskList) {
    // logger.i(item.toJson());
    strList.add(item.toJson());
  }
  return prefs.setStringList(prefsKey, strList);
}

/**
 * 更新任务
 */
Future<bool> updateM3u8Task(M3u8Task task) async {
  final SharedPreferences prefs = await _prefs;
  List<M3u8Task> taskList = await getM3u8TaskList();
  List<String> strList = [];
  for (M3u8Task item in taskList) {
    if (item.id == task.id) {
      // logger.i(task.toJson());
      strList.add(task.toJson());
    } else {
      strList.add(item.toJson());
    }
  }
  // logger.i(strList);
  return prefs.setStringList(prefsKey, strList);
}

/**
 * 删除任务
 */
Future<bool> deleteM3u8Task(M3u8Task task) async {
  final SharedPreferences prefs = await _prefs;
  List<M3u8Task> taskList = await getM3u8TaskList();
  List<String> strList = [];
  for (M3u8Task item in taskList) {
    if (item.id != task.id) {
      // print(item.toString());
      strList.add(item.toJson());
    }
  }
  return prefs.setStringList(prefsKey, strList);
}

/**
 * 判断是否存在相同的m3u8name和subname */
Future<bool> hasM3u8Name(String m3u8name, String subname) async {
  List<M3u8Task> taskList = await getM3u8TaskList();
  for (M3u8Task item in taskList) {
    if (item.m3u8name == m3u8name && item.subname == subname) {
      return true;
    }
  }
  return false;
}

/**
 * 清空任务
 */
Future<bool> clearM3u8Task() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.remove(prefsKey);
}
