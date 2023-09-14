import 'package:floor/floor.dart';

@Entity(tableName: 'M3u8Task')
class M3u8Task {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  String m3u8name;
  String subname;
  String m3u8url;
  String? keyurl;
  String? iv;
  String? downdir;
  int? status; //1等待下载  2：下载中  3：下载完成

  M3u8Task(
      {this.id,
      required this.m3u8url,
      required this.m3u8name,
      required this.subname,
      this.keyurl,
      this.iv,
      this.downdir,
      this.status});

  @override
  String toString() {
    // TODO: implement toString
    return '{id: $id,m3u8url: $m3u8url, m3u8name: $m3u8name,keyurl: $keyurl,iv: $iv,downdir: $downdir,status: $status}';
  }
}
