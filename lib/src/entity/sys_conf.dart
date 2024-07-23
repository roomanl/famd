import 'dart:convert';

class SysConf {
  int? id;
  String name;
  String value;

  SysConf({
    this.id,
    required this.name,
    required this.value,
  });

  String toJson() => json.encode(toMap());
  factory SysConf.fromJson(String source) =>
      SysConf.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
    };
  }

  factory SysConf.fromMap(Map<String, dynamic> map) {
    return SysConf(
      id: map['id']?.toInt(),
      name: map['name'].toString(),
      value: map['value'].toString(),
    );
  }
  @override
  String toString() {
    return '{id: $id, name: $name, value: $value}';
  }
}
