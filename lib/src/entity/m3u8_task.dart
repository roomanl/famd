import 'dart:convert';

class M3u8Task {
  int? id;
  late String m3u8name;
  late String subname;
  late String m3u8url;
  String? keyurl;
  String? keyvalue;
  String? iv;
  String? downdir;
  int? status; //1未下载2下载中3下载完成4下载失败

  M3u8Task(
      {this.id,
      required this.m3u8name,
      required this.subname,
      required this.m3u8url,
      this.keyurl,
      this.keyvalue,
      this.iv,
      this.downdir,
      this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'm3u8name': m3u8name,
      'subname': subname,
      'm3u8url': m3u8url,
      'keyurl': keyurl,
      'iv': iv,
      'downdir': downdir,
      'status': status,
      'keyvalue': keyvalue,
    };
  }

  factory M3u8Task.fromMap(Map<String, dynamic> map) {
    return M3u8Task(
        id: map['id']?.toInt(),
        m3u8name: map['m3u8name'].toString(),
        subname: map['subname'].toString(),
        m3u8url: map['m3u8url'].toString(),
        keyurl: map['keyurl']?.toString(),
        iv: map['iv']?.toString(),
        downdir: map['downdir']?.toString(),
        status: map['status']?.toInt(),
        keyvalue: map['keyvalue']?.toString());
  }

  String toJson() => json.encode(toMap());

  factory M3u8Task.fromJson(String source) =>
      M3u8Task.fromMap(json.decode(source));

  @override
  String toString() {
    return '{id:$id, m3u8name:$m3u8name, subname:$subname, m3u8url:$m3u8url, keyurl:$keyurl, iv:$iv, downdir:$downdir, status:$status, keyvalue:$keyvalue}';
  }
}
