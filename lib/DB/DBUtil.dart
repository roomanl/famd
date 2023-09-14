import 'package:floor/floor.dart';
import 'dao/SysConfigDao.dart';
import 'dao/M3u8TaskDao.dart';
import 'entity/SysConfig.dart';
import 'entity/M3u8Task.dart';
import 'database.dart';

class DBUtil {
  //单例
  DBUtil._();
  static DBUtil? _singleton;
  factory DBUtil() => _singleton ??= DBUtil._();
  void dispose() => _singleton = null;
  //定义数据库变量
  late final AppDatabase _db;
  SysConfigDao get sysConfigDao => _db.sysConfigDao;
  M3u8TaskDao get m3u8TaskDao => _db.m3u8TaskDao;

  @Database(version: 3, entities: [SysConfig, M3u8Task])
  initDB() async {
    _db = await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .addMigrations(
      [migration1to2],
    ).build();
  }

  //迁移策略,数据库版本1->2
  final migration1to2 = Migration(2, 3, (database) async {
    await database.execute(
        'CREATE TABLE IF NOT EXISTS `M3u8Task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `m3u8name` TEXT NOT NULL, `subname` TEXT NOT NULL, `m3u8url` TEXT NOT NULL, `keyurl` TEXT, `iv` TEXT, `downdir` TEXT, `status` INTEGER)');
  });
}
