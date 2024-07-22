import 'dart:convert';

class TsInfo {
  int? id;
  int pid;
  String tsurl;
  String filename;

  int? get getId => this.id;
  set setId(int id) => this.id = id;
  int get getPid => this.pid;
  set setPid(int pid) => this.pid = pid;
  String get getTsurl => this.tsurl;
  set setTsurl(String tsurl) => this.tsurl = tsurl;
  String get getFilename => this.filename;
  set setFilename(String filename) => this.filename = filename;

  TsInfo({
    this.id,
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
