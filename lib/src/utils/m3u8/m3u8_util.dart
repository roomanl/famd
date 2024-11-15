import 'dart:typed_data';

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
  Uint8List? byteKey;
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
          line.endsWith('.jpeg') ||
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
    if ((keyUrl ?? "").isNotEmpty) {
      await downloadKey(keyUrl);
    }
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
    _m3u8url = task.m3u8url;
    // List<TsInfo> tsList = await getTsListByPid(task.id!);
    // if (tsList.isEmpty ||
    //     (task.keyurl ?? "").isEmpty ||
    //     (task.iv ?? "").isEmpty ||
    //     (task.keyvalue ?? "").isEmpty) {
    deleteTsByPid(task.id!);
    debugPrint('开始解析M3U8！');
    return _parse();
    // }
    // debugPrint('已经解析过M3U8，跳过解析！');
    // this.tsList = tsList;
    // iv = task.iv!;
    // keyUrl = task.keyurl!;
    // keyValue = task.keyvalue!;
    // return true;
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

  downloadKey(String? url) async {
    try {
      var keyres = await http.get(Uri.parse(url ?? keyUrl!));
      if (keyres.statusCode == 200) {
        keyValue = keyres.body;
        byteKey = keyres.bodyBytes;
      }
      return keyres;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  getKeyStr(String? url) async {
    var keyres = await downloadKey(url);
    if (keyres != null) {
      return keyres.body;
    }
    return null;
  }

  getKeyByte(String? url) async {
    var keyres = await downloadKey(url);
    if (keyres != null) {
      return keyres.bodyBytes;
    }
    return null;
  }
}
