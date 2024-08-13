import 'dart:math';

import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/models/ts_info.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class M3u8Util {
  late M3u8Task _task;
  late String _m3u8url;
  late Uri _parsuri;
  String? iv;
  String? keyUrl;
  String? keyValue;
  List<TsInfo> tsList = [];

  M3u8Util() {}

  _parse() async {
    tsList = [];
    _parsuri = Uri.parse(_m3u8url);
    // var res = await Dio().get(m3u8url);
    var res = await http.get(_parsuri);
    // logger.i(m3u8url);
    //_logger.i(res.statusCode);
    //_logger.i(res.body);
    // return false;
    // logger.i(resText);
    if (res.statusCode != 200) {
      return false;
    }
    String resText = res.body;
    List<String> lines = resText.split('\n');
    int tsCount = 0;
    for (String line in lines) {
      if (line.endsWith('.ts') ||
          line.endsWith('.image') ||
          line.endsWith('.png') ||
          line.endsWith('.jpg') ||
          line.contains('.ts?')) {
        tsCount++;
        String filename = '${tsCount.toString().padLeft(4, '0')}.ts';
        TsInfo tsInfo = TsInfo(
            pid: _task.id!, tsurl: _getRealUrl(line), filename: filename);
        tsList.add(tsInfo);
        insertTsInfo(tsInfo);
      } else if (line.startsWith('#EXT-X-KEY')) {
        _getKey(line);
      } else if (line.contains('.m3u8')) {
        _m3u8url = _getRealUrl(line);
        // print(m3u8url);
        return _parse();
      }
    }
    await keyValueStr(null);
    return true;
  }

  parseByTaskId(int id) async {
    M3u8Task? task = await getM3u8TaskById(id);
    if (task == null) {
      return false;
    }
    return parseByTask(task);
  }

  parseByTask(M3u8Task task) async {
    _task = task;
    List<TsInfo> tsList = await getTsListByPid(task.id!);
    _m3u8url = task.m3u8url;
    if (tsList.isEmpty ||
        (task.keyurl ?? "").isEmpty ||
        (task.iv ?? "").isEmpty ||
        (task.keyvalue ?? "").isEmpty) {
      deleteTsByPid(task.id!);
      debugPrint('开始解析M3U8！');
      return _parse();
    }
    debugPrint('已经解析过M3U8，跳过解析！');
    this.tsList = tsList;
    iv = task.iv!;
    keyUrl = task.keyurl!;
    keyValue = task.keyvalue!;
    return true;
  }

  _getKey(String line) {
    List<String> lines = line.split(',');
    for (String item in lines) {
      if (item.startsWith('URI')) {
        String keyPath = item.split('=')[1].replaceAll('"', '');
        keyUrl = _getRealUrl(keyPath);
      } else if (item.startsWith('IV')) {
        iv = lines[1].split('=')[1];
      }
    }
    if (lines.length > 2) {
      iv = lines[2].split('=')[1];
    }
    // logger.i(IV);
    // logger.i(keyUrl);
  }

  _getRealUrl(line) {
    // print(line);
    String realUrl = '';
    if (line.startsWith('http')) {
      realUrl = line;
    } else if (line.startsWith('/')) {
      realUrl = "${_parsuri.scheme}://${_parsuri.host}$line";
    } else {
      int index = _m3u8url.lastIndexOf("/");
      realUrl = _m3u8url.substring(0, index + 1) + line;
    }
    return realUrl.trim();
  }

  keyValueStr(String? url) async {
    try {
      var keyres = await http.get(Uri.parse(url ?? keyUrl!));
      if (keyres.statusCode == 200) {
        keyValue = keyres.body;
      }
    } catch (e) {}
    return keyValue;
  }

  parseTsUrl(String url) {
    if (url.contains('&ip=')) {
      return _replaceIPInString(url);
    }
    return url;
  }

  String _replaceIPInString(String originalString) {
    RegExp regex = RegExp(r'&ip=(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(&|$)');
    RegExpMatch? match = regex.firstMatch(originalString);
    if (match != null) {
      String newIP = _generateRandomIP();
      return originalString.replaceFirst(
          regex, "&ip=$newIP${match.group(2) ?? ''}");
    } else {
      return originalString;
    }
  }

  String _generateRandomIP() {
    Random random = Random();
    // 生成四组数字，每组表示IP地址的一部分
    int part1 = random.nextInt(256);
    int part2 = random.nextInt(256);
    int part3 = random.nextInt(256);
    int part4 = random.nextInt(256);
    // 将这四部分组合成一个IP地址字符串
    return "$part1.$part2.$part3.$part4";
  }
}
