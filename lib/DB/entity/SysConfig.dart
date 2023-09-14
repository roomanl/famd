import 'package:floor/floor.dart';

@Entity(tableName: 'SysConfig')
class SysConfig {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final String value;

  SysConfig({this.id, required this.name, required this.value});
}
