import 'package:famd/src/common/const.dart';
import 'package:famd/src/db/DBHelper.dart';
import 'package:famd/src/entity/sys_conf.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBSysConf {
  late Future<Database> _db;
  late String tableName = DB_TABLE_NAME['sysconf']!;
  DBSysConf() {
    //print("DBSysConf");
    _db = DBHelper.getInstance().database;
  }

  Future<int> insert(SysConf params) async {
    // print("插入的数据:${params.toJson()}");
    final db = await _db;
    SysConf? conf = await queryFirstByName(params.name);
    if (conf == null) {
      return await db.insert(tableName, params.toMap());
    } else {
      conf.value = params.value;
      return await update(conf);
    }
  }

  // 查询特定记录
  Future<SysConf?> queryFirstByName(String name) async {
    final db = await _db;
    List<Map<String, dynamic>> list = await db.query(
      tableName,
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );
    if (list.isNotEmpty) {
      return SysConf.fromMap(list.first);
    }
    return null;
  }

  Future<List<SysConf>> queryAll() async {
    final db = await _db;
    List<Map<String, dynamic>> list = await db.query(tableName);
    if (list.isNotEmpty) {
      return list.map((item) => SysConf.fromMap(item)).toList();
    }
    return [];
  }

  Future<int> update(SysConf params) async {
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
}
