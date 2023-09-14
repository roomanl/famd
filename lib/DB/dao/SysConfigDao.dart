// dao/person_dao.dart

import 'package:floor/floor.dart';
import '../entity/SysConfig.dart';

@dao
abstract class SysConfigDao {
  @Query('SELECT * FROM SysConfig')
  Future<List<SysConfig>> findAllSysConfig();

  @Query('SELECT * FROM SysConfig WHERE name = :name')
  Future<SysConfig?> findSysConfigByName(String name);

  @Query('SELECT * FROM SysConfig WHERE id = :id')
  Future<SysConfig?> findSysConfigById(int id);

  @Query('delete from SysConfig where name=:name')
  Future<void> deleteSysConfigByName(String name);

  @Query('update SysConfig set value=:value where name=:name')
  Future<void> updateSysConfigByName(String name, String value);

  @insert
  Future<void> insertSysConfig(SysConfig config);
}
