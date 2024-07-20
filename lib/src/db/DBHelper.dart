import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi/windows/sqflite_ffi_setup.dart';
import '../common/const.dart';

class DBHelper {
  static DBHelper? _dbHelper;

  static DBHelper getInstance() {
    _dbHelper ??= DBHelper();
    return _dbHelper!;
  }

  Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
    return _db!;
  }

  initDB() async {
    //1、初始化数据库
    sqfliteFfiInit();
    //2、获取databaseFactoryFfi对象
    var databaseFactory = databaseFactoryFfi;
    //3、创建数据库
    return await databaseFactory.openDatabase(
        //数据库路径
        path.join(await databaseFactory.getDatabasesPath(), "famd_m3u8.db"),

        //打开数据库操作
        options: OpenDatabaseOptions(
            //版本
            version: 1,
            //创建时操作
            onCreate: (db, version) async {
              print("创建数据库");
              await db.execute('''
                  CREATE TABLE $DB_TABLE_NAME['m3u8task'] (
                  id STRING PRIMARY KEY,
                  m3u8name STRING,
                  subname STRING,
                  m3u8url STRING,
                  keyurl STRING,
                  iv STRING,
                  status INTEGER)
                ''');
              await db.execute('''
                  CREATE TABLE $DB_TABLE_NAME['tsinfo'] (
                  id STRING PRIMARY KEY,
                  pid STRING,
                  tsurl STRING,
                  filename STRING)
                ''');
              await db.execute('''
                  CREATE TABLE $DB_TABLE_NAME['sysconf'] (
                  id STRING PRIMARY KEY,
                  name STRING,
                  value STRING)
                ''');
            }));
  }
}
