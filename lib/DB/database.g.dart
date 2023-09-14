// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SysConfigDao? _sysConfigDaoInstance;

  M3u8TaskDao? _m3u8TaskDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SysConfig` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `value` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `M3u8Task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `m3u8name` TEXT NOT NULL, `subname` TEXT NOT NULL, `m3u8url` TEXT NOT NULL, `keyurl` TEXT, `iv` TEXT, `downdir` TEXT, `status` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SysConfigDao get sysConfigDao {
    return _sysConfigDaoInstance ??= _$SysConfigDao(database, changeListener);
  }

  @override
  M3u8TaskDao get m3u8TaskDao {
    return _m3u8TaskDaoInstance ??= _$M3u8TaskDao(database, changeListener);
  }
}

class _$SysConfigDao extends SysConfigDao {
  _$SysConfigDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _sysConfigInsertionAdapter = InsertionAdapter(
            database,
            'SysConfig',
            (SysConfig item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'value': item.value
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SysConfig> _sysConfigInsertionAdapter;

  @override
  Future<List<SysConfig>> findAllSysConfig() async {
    return _queryAdapter.queryList('SELECT * FROM SysConfig',
        mapper: (Map<String, Object?> row) => SysConfig(
            id: row['id'] as int?,
            name: row['name'] as String,
            value: row['value'] as String));
  }

  @override
  Future<SysConfig?> findSysConfigByName(String name) async {
    return _queryAdapter.query('SELECT * FROM SysConfig WHERE name = ?1',
        mapper: (Map<String, Object?> row) => SysConfig(
            id: row['id'] as int?,
            name: row['name'] as String,
            value: row['value'] as String),
        arguments: [name]);
  }

  @override
  Future<SysConfig?> findSysConfigById(int id) async {
    return _queryAdapter.query('SELECT * FROM SysConfig WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SysConfig(
            id: row['id'] as int?,
            name: row['name'] as String,
            value: row['value'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteSysConfigByName(String name) async {
    await _queryAdapter.queryNoReturn('delete from SysConfig where name=?1',
        arguments: [name]);
  }

  @override
  Future<void> updateSysConfigByName(
    String name,
    String value,
  ) async {
    await _queryAdapter.queryNoReturn(
        'update SysConfig set value=?2 where name=?1',
        arguments: [name, value]);
  }

  @override
  Future<void> insertSysConfig(SysConfig config) async {
    await _sysConfigInsertionAdapter.insert(config, OnConflictStrategy.abort);
  }
}

class _$M3u8TaskDao extends M3u8TaskDao {
  _$M3u8TaskDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _m3u8TaskInsertionAdapter = InsertionAdapter(
            database,
            'M3u8Task',
            (M3u8Task item) => <String, Object?>{
                  'id': item.id,
                  'm3u8name': item.m3u8name,
                  'subname': item.subname,
                  'm3u8url': item.m3u8url,
                  'keyurl': item.keyurl,
                  'iv': item.iv,
                  'downdir': item.downdir,
                  'status': item.status
                }),
        _m3u8TaskUpdateAdapter = UpdateAdapter(
            database,
            'M3u8Task',
            ['id'],
            (M3u8Task item) => <String, Object?>{
                  'id': item.id,
                  'm3u8name': item.m3u8name,
                  'subname': item.subname,
                  'm3u8url': item.m3u8url,
                  'keyurl': item.keyurl,
                  'iv': item.iv,
                  'downdir': item.downdir,
                  'status': item.status
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<M3u8Task> _m3u8TaskInsertionAdapter;

  final UpdateAdapter<M3u8Task> _m3u8TaskUpdateAdapter;

  @override
  Future<List<M3u8Task>> findAllM3u8Task() async {
    return _queryAdapter.queryList('SELECT * FROM M3u8Task order by id',
        mapper: (Map<String, Object?> row) => M3u8Task(
            id: row['id'] as int?,
            m3u8url: row['m3u8url'] as String,
            m3u8name: row['m3u8name'] as String,
            subname: row['subname'] as String,
            keyurl: row['keyurl'] as String?,
            iv: row['iv'] as String?,
            downdir: row['downdir'] as String?,
            status: row['status'] as int?));
  }

  @override
  Future<M3u8Task?> findM3u8TaskById(int id) async {
    return _queryAdapter.query('SELECT * FROM M3u8Task WHERE id = ?1',
        mapper: (Map<String, Object?> row) => M3u8Task(
            id: row['id'] as int?,
            m3u8url: row['m3u8url'] as String,
            m3u8name: row['m3u8name'] as String,
            subname: row['subname'] as String,
            keyurl: row['keyurl'] as String?,
            iv: row['iv'] as String?,
            downdir: row['downdir'] as String?,
            status: row['status'] as int?),
        arguments: [id]);
  }

  @override
  Future<M3u8Task?> findM3u8TaskByName(String m3u8name) async {
    return _queryAdapter.query('SELECT * FROM M3u8Task WHERE m3u8name = ?1',
        mapper: (Map<String, Object?> row) => M3u8Task(
            id: row['id'] as int?,
            m3u8url: row['m3u8url'] as String,
            m3u8name: row['m3u8name'] as String,
            subname: row['subname'] as String,
            keyurl: row['keyurl'] as String?,
            iv: row['iv'] as String?,
            downdir: row['downdir'] as String?,
            status: row['status'] as int?),
        arguments: [m3u8name]);
  }

  @override
  Future<void> deleteM3u8TaskById(int id) async {
    await _queryAdapter
        .queryNoReturn('delete from M3u8Task where id=?1', arguments: [id]);
  }

  @override
  Future<void> insertM3u8Task(M3u8Task m3u8task) async {
    await _m3u8TaskInsertionAdapter.insert(m3u8task, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateM3u8Task(M3u8Task m3u8task) async {
    await _m3u8TaskUpdateAdapter.update(m3u8task, OnConflictStrategy.abort);
  }
}
