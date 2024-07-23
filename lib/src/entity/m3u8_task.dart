import 'dart:convert';

class M3u8Task {
  late int? _id;
  late String _m3u8name;
  late String _subname;
  late String _m3u8url;
  late String? _keyurl;
  late String? _keyvalue;
  late String? _iv;
  late String? _downdir;
  late int? _status; //1未下载2下载中3下载完成4下载失败

  get getId => _id;

  set setId(id) => _id = id;

  get getM3u8name => _m3u8name;

  set setM3u8name(m3u8name) => _m3u8name = m3u8name;

  get getSubname => _subname;

  set setSubname(subname) => _subname = subname;

  get getM3u8url => _m3u8url;

  set setM3u8url(m3u8url) => _m3u8url = m3u8url;

  get getKeyurl => _keyurl;

  set setKeyurl(keyurl) => _keyurl = keyurl;

  get getIv => _iv;

  set setIv(iv) => _iv = iv;

  get getDowndir => _downdir;

  set setDowndir(downdir) => _downdir = downdir;

  get getStatus => _status;

  set setStatus(status) => _status = status;

  String? get getKeyvalue => _keyvalue;

  set setKeyvalue(keyvalue) => _keyvalue = keyvalue;

  M3u8Task(
      {int? id,
      required String m3u8name,
      required String subname,
      required String m3u8url,
      String? keyurl,
      String? keyvalue,
      String? iv,
      String? downdir,
      int? status}) {
    _id = id;
    _m3u8name = m3u8name;
    _subname = subname;
    _m3u8url = m3u8url;
    _keyurl = keyurl;
    _keyvalue = keyvalue;
    _iv = iv;
    _downdir = downdir;
    _status = status;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'm3u8name': _m3u8name,
      'subname': _subname,
      'm3u8url': _m3u8url,
      'keyurl': _keyurl,
      'iv': _iv,
      'downdir': _downdir,
      'status': _status,
      'keyvalue': _keyvalue,
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
    return '{id:$_id, m3u8name:$_m3u8name, subname:$_subname, m3u8url:$_m3u8url, keyurl:$_keyurl, iv:$_iv, downdir:$_downdir, status:$_status, keyvalue:$_keyvalue}';
  }
}
