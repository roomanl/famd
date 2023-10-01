import 'dart:convert';

class M3u8Task {
  String id;
  String m3u8name;
  String subname;
  String m3u8url;
  String? keyurl;
  String? iv;
  String? downdir;
  int? status; //1未下载2下载中3下载完成4下载失败
  String get getId => this.id;

  set setId(String id) => this.id = id;

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

  get getStatus => this.status;

  set setStatus(status) => this.status = status;
  M3u8Task(
      {required this.id,
      required this.m3u8name,
      required this.subname,
      required this.m3u8url,
      this.keyurl,
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
    };
  }

  factory M3u8Task.fromMap(Map<String, dynamic> map) {
    return M3u8Task(
        id: map['id'] ?? '',
        m3u8name: map['m3u8name'] ?? '',
        subname: map['subname'] ?? '',
        m3u8url: map['m3u8url'] ?? '',
        keyurl: map['keyurl'],
        iv: map['iv'],
        downdir: map['downdir'],
        status: map['status']?.toInt());
  }

  String toJson() => json.encode(toMap());

  factory M3u8Task.fromJson(String source) =>
      M3u8Task.fromMap(json.decode(source));

  @override
  String toString() {
    return '{id:$id, m3u8name:$m3u8name, subname:$subname, m3u8url:$m3u8url, keyurl:$keyurl, iv:$iv, downdir:$downdir, status:$status}';
  }
}
