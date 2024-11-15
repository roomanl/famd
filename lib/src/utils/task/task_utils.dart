import 'dart:io';

import 'package:famd/src/utils/db/DBM3u8Task.dart';
import 'package:famd/src/utils/db/DBTsInfo.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/models/ts_info.dart';
import 'package:famd/src/utils/file/file_utils.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';

final DBM3u8Task dbm3u8task = DBM3u8Task();
final DBTsInfo dbTsInfo = DBTsInfo();

Future<List<M3u8Task>> getM3u8TaskList() async {
  return await dbm3u8task.queryAll();
}

Future<M3u8Task?> getM3u8TaskById(int id) async {
  return await dbm3u8task.queryFirstById(id);
}

Future<bool> insertM3u8Task(M3u8Task task) async {
  int result = await dbm3u8task.insert(task);
  return result > 0;
}

Future<bool> updateM3u8Task(M3u8Task task) async {
  if (task.id == null) {
    return false;
  }
  int result = await dbm3u8task.update(task);
  return result > 0;
}

Future<bool> deleteM3u8Task(M3u8Task task) async {
  if (task.id == null) {
    return false;
  }
  deleteTsByPid(task.id!);
  int result = await dbm3u8task.deleteById(task.id!);
  return result > 0;
}

Future<bool> clearM3u8Task() async {
  List<M3u8Task> list = await getM3u8TaskList();
  print(list.length);
  String pathSeparator = Platform.pathSeparator;
  for (M3u8Task task in list) {
    String dir = task.downdir! + pathSeparator + task.m3u8name;
    print(dir);
    deleteDir(dir);
  }
  await dbTsInfo.delete();
  int result = await dbm3u8task.delete();
  return result > 0;
}

Future<bool> hasM3u8Name(String m3u8name, String subname) async {
  M3u8Task? task = await dbm3u8task.queryFirstByName(m3u8name, subname);
  return task != null ? true : false;
}

Future<List<TsInfo>> getTsListByPid(int pid) async {
  return await dbTsInfo.queryByPid(pid);
}

Future<bool> insertTsInfo(TsInfo tsInfo) async {
  int result = await dbTsInfo.insert(tsInfo);
  return result > 0;
}

Future<bool> deleteTsByPid(int pid) async {
  int result = await dbTsInfo.deleteByPid(pid);
  return result > 0;
}

taskFullName(M3u8Task task) {
  return '${task.m3u8name}-${task.subname}';
}

taskFullMp4Path(M3u8Task task) {
  return '${task.downdir}/${task.m3u8name}/${task.m3u8name}-${task.subname}.mp4';
}

taskFullTsDir(M3u8Task task) {
  return '${task.downdir}/${task.m3u8name}/${task.subname}';
}
