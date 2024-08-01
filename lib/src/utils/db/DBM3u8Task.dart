import 'package:famd/src/common/const.dart';
import 'package:famd/src/utils/db/DBHelper.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBM3u8Task {
  late Future<Database> _db;
  late String tableName = DB_TABLE_NAME['m3u8task']!;
  DBM3u8Task() {
    _db = DBHelper.getInstance().database;
  }
  Future<int> insert(M3u8Task params) async {
    // print("插入的数据:${params.toJson()}");
    final db = await _db;
    M3u8Task? task = await queryFirstByName(params.m3u8name, params.subname);
    if (task == null) {
      return await db.insert(tableName, params.toMap());
    }
    return 0;
  }

  Future<M3u8Task?> queryFirstByName(String m3u8name, String subname) async {
    final db = await _db;
    List<Map<String, dynamic>> list = await db.query(
      tableName,
      where: 'm3u8name = ? and subname = ?',
      whereArgs: [m3u8name, subname],
      limit: 1,
    );
    if (list.isNotEmpty) {
      return M3u8Task.fromMap(list.first);
    }
    return null;
  }

  Future<M3u8Task?> queryFirstById(int id) async {
    final db = await _db;
    List<Map<String, dynamic>> list = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (list.isNotEmpty) {
      return M3u8Task.fromMap(list.first);
    }
    return null;
  }

  Future<List<M3u8Task>> queryAll() async {
    final db = await _db;
    List<Map<String, dynamic>> list =
        await db.query(tableName, orderBy: 'createtime ASC');
    if (list.isNotEmpty) {
      return list.map((item) => M3u8Task.fromMap(item)).toList();
    }
    return [];
  }

  Future<int> update(M3u8Task params) async {
    if (params.id == null) {
      return 0;
    }
    final db = await _db;
    return await db.update(
      tableName,
      params.toMap(),
      where: 'id = ?',
      whereArgs: [params.id],
    );
  }

  Future<int> delete() async {
    final db = await _db;
    return await db.delete(tableName);
  }

  Future<int> deleteById(int id) async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
