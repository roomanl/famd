// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/SysConfigDao.dart';
import 'entity/SysConfig.dart';

import 'dao/M3u8TaskDao.dart';
import 'entity/M3u8Task.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 2, entities: [SysConfig, M3u8Task])
abstract class AppDatabase extends FloorDatabase {
  SysConfigDao get sysConfigDao;
  M3u8TaskDao get m3u8TaskDao;
}
