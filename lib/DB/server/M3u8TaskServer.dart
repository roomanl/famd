import '../entity/M3u8Task.dart';
import '../DBUtil.dart';

Future<List<M3u8Task>> findAllM3u8Task() async {
  List<M3u8Task> list = await DBUtil().m3u8TaskDao.findAllM3u8Task();
  return list;
}

Future<M3u8Task?> findM3u8TaskById(int id) async {
  M3u8Task? task = await DBUtil().m3u8TaskDao.findM3u8TaskById(id);
  return task;
}

Future<M3u8Task?> findM3u8TaskByName(String m3u8name) async {
  M3u8Task? task = await DBUtil().m3u8TaskDao.findM3u8TaskByName(m3u8name);
  return task;
}

void deleteM3u8TaskById(int id) async {
  await DBUtil().m3u8TaskDao.deleteM3u8TaskById(id);
}

void updateM3u8Task(M3u8Task m3u8task) async {
  await DBUtil().m3u8TaskDao.updateM3u8Task(m3u8task);
}

void insertM3u8Task(M3u8Task m3u8task) async {
  await DBUtil().m3u8TaskDao.insertM3u8Task(m3u8task);
}
