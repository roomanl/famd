import 'package:famd/src/common/const.dart';
import 'package:famd/src/db/DBHelper.dart';
import 'package:famd/src/entity/ts_info.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBTsInfo {
  late Future<Database> _db;
  late String tableName = DB_TABLE_NAME['tsinfo']!;
  DBTsInfo() {
    _db = DBHelper.getInstance().database;
  }

  Future<int> insert(TsInfo params) async {
    // print("插入的数据:${params.toJson()}");
    final db = await _db;
    return await db.insert(tableName, params.toMap());
  }

  Future<List<TsInfo>> queryAll() async {
    final db = await _db;
    List<Map<String, dynamic>> list = await db.query(tableName);
    if (list.isNotEmpty) {
      return list.map((item) => TsInfo.fromMap(item)).toList();
    }
    return [];
  }

  Future<List<TsInfo>> queryByPid(int pid) async {
    final db = await _db;
    List<Map<String, dynamic>> list = await db.query(
      tableName,
      where: 'pid = ?',
      whereArgs: [pid],
    );
    if (list.isNotEmpty) {
      return list.map((item) => TsInfo.fromMap(item)).toList();
    }
    return [];
  }

  Future<int> update(TsInfo params) async {
    if (params.getId == null) {
      return 0;
    }
    final db = await _db;
    return await db.update(
      tableName,
      params.toMap(),
      where: 'id = ?',
      whereArgs: [params.getId],
    );
  }

  Future<int> delete() async {
    final db = await _db;
    return await db.delete(tableName);
  }

  Future<int> deleteByPid(int pid) async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: 'pid = ?',
      whereArgs: [pid],
    );
  }
}
