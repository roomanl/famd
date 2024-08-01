import 'package:famd/src/utils/file/file_utils.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../common/const.dart';

class DBHelper {
  static DBHelper? _dbHelper;

  static DBHelper getInstance() {
    //print("单例模式1");
    _dbHelper ??= DBHelper();
    return _dbHelper!;
  }

  Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    //print("单例模式2");
    _db = await initDB();
    return _db!;
  }

  initDB() async {
    //1、初始化数据库
    //print("1、初始化数据库");
    sqfliteFfiInit();
    //2、获取databaseFactoryFfi对象
    //print("2、获取databaseFactoryFfi对象");
    var databaseFactory = databaseFactoryFfi;
    print(path.join(await getDBFilePath(), "famd_m3u8.db"));
    //3、创建数据库
    return await databaseFactory.openDatabase(
      //数据库路径
      path.join(await getDBFilePath(), "famd_m3u8.db"),

      //打开数据库操作
      options: OpenDatabaseOptions(
        //版本
        version: 1,
        //创建时操作
        onCreate: (db, version) async {
          print("创建数据库");
          await db.execute('''
                  CREATE TABLE ${DB_TABLE_NAME['m3u8task']} (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  m3u8name STRING,
                  subname STRING,
                  m3u8url STRING,
                  keyurl STRING,
                  keyvalue STRING,
                  iv STRING,
                  downdir STRING,
                  remarks STRING,
                  filesize STRING,
                  status INTEGER,
                  createtime STRING)
                ''');
          await db.execute('''
                  CREATE TABLE ${DB_TABLE_NAME['tsinfo']} (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  pid STRING,
                  tsurl STRING,
                  filename STRING)
                ''');
          await db.execute('''
                  CREATE TABLE ${DB_TABLE_NAME['sysconf']} (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  name STRING,
                  value STRING)
                ''');
        },
        onDowngrade: (Database db, int oldVersion, int newVersion) async {
          print("数据库修改,oldVersion:$oldVersion,newVersion:$newVersion");
          if (oldVersion < newVersion) {}
        },
      ),
    );
  }
}
