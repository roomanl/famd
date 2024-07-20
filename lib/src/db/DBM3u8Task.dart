import 'package:famd/src/db/DBHelper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBM3u8Task {
  late Database db;
  DBM3u8Task() {
    db = DBHelper.getInstance().database as Database;
  }
}
