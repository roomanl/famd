// dao/person_dao.dart

import 'package:floor/floor.dart';
import '../entity/M3u8Task.dart';

@dao
abstract class M3u8TaskDao {
  @Query('SELECT * FROM M3u8Task order by id')
  Future<List<M3u8Task>> findAllM3u8Task();

  @Query('SELECT * FROM M3u8Task WHERE id = :id')
  Future<M3u8Task?> findM3u8TaskById(int id);

  @Query('SELECT * FROM M3u8Task WHERE m3u8name = :m3u8name')
  Future<M3u8Task?> findM3u8TaskByName(String m3u8name);

  @Query('delete from M3u8Task where id=:id')
  Future<void> deleteM3u8TaskById(int id);

  @update
  Future<void> updateM3u8Task(M3u8Task m3u8task);

  @insert
  Future<void> insertM3u8Task(M3u8Task m3u8task);
}
