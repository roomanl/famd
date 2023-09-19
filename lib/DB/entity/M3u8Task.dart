import 'package:floor/floor.dart';

@Entity(tableName: 'M3u8Task')
class M3u8Task {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String m3u8name;
  String subname;
  String m3u8url;
  String? keyurl;
  String? iv;
  String? downdir;
  int? status; //1等待下载  2：下载中  3：下载完成
  get getId => this.id;

  set setId(id) => this.id = id;

  get getM3u8name => this.m3u8name;

  set setM3u8name(m3u8name) => this.m3u8name = m3u8name;

  get getSubname => this.subname;

  set setSubname(subname) => this.subname = subname;

  get getM3u8url => this.m3u8url;

  set setM3u8url(m3u8url) => this.m3u8url = m3u8url;

  get getKeyurl => this.keyurl;

  set setKeyurl(keyurl) => this.keyurl = keyurl;

  get getIv => this.iv;

  set setIv(iv) => this.iv = iv;

  get getDowndir => this.downdir;

  set setDowndir(downdir) => this.downdir = downdir;

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
