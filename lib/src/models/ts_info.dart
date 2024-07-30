import 'dart:convert';

class TsInfo {
  int? id;
  int pid;
  String tsurl;
  String filename;

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
      id: map['id']?.toInt(),
      pid: map['pid'].toInt(),
      tsurl: map['tsurl'].toString(),
      filename: map['filename'].toString(),
    );
  }
  String toJson() => json.encode(toMap());
  factory TsInfo.fromJson(String source) => TsInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return '{id: $id, pid: $pid, tsurl: $tsurl, filename: $filename}';
  }
}
