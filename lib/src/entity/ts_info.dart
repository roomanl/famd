import 'dart:convert';

class TsInfo {
  String id;
  String pid;
  String tsurl;
  String filename;

  String get getId => this.id;
  set setId(String id) => this.id = id;
  String get getPid => this.pid;
  set setPid(String pid) => this.pid = pid;
  String get getTsurl => this.tsurl;
  set setTsurl(String tsurl) => this.tsurl = tsurl;

  TsInfo({
    required this.id,
    required this.pid,
    required this.tsurl,
    required this.filename,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pid': pid,
      'tsurl': tsurl,
      'filename': filename,
    };
  }

  factory TsInfo.fromMap(Map<String, dynamic> map) {
    return TsInfo(
      id: map['id'] ?? '',
      pid: map['pid'] ?? '',
      tsurl: map['tsurl'] ?? '',
      filename: map['filename'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());
  factory TsInfo.fromJson(String source) => TsInfo.fromMap(json.decode(source));

  String toString() {
    return '{id: $id, pid: $pid, tsurl: $tsurl, filename: $filename}';
  }
}
