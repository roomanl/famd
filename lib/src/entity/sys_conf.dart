import 'dart:convert';

class SysConf {
  String id;
  String name;
  String value;

  String get getId => this.id;
  set setId(String id) => this.id = id;
  String get getName => this.name;
  set setName(String name) => this.name = name;
  String get getValue => this.value;
  set setValue(String value) => this.value = value;

  SysConf({
    required this.id,
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
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      value: map['value'] ?? '',
    );
  }
  String toString() {
    return '{id: $id, name: $name, value: $value}';
  }
}
