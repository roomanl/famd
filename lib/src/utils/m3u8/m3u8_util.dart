import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/models/ts_info.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class M3u8Util {
  late M3u8Task _task;
  late String _m3u8url;
  late Uri _parsuri;
  late Logger _logger;
  String? iv;
  String? keyUrl;
  String? keyValue;
  List<TsInfo> tsList = [];

  M3u8Util() {
    _logger = Logger();
  }

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
      _logger.i('开始解析M3U8！');
      return _parse();
    }
    _logger.i('已经解析过M3U8，跳过解析！');
    this.tsList = tsList;
    iv = task.iv!;
    keyUrl = task.keyurl!;
    keyValue = task.keyvalue!;
    return true;
  }

  _getKey(String line) {
    List<String> lines = line.split(',');
    if (lines.length > 2) {
      iv = lines[2].split('=')[1];
    }
    String keyPath = lines[1].split('=')[1].replaceAll('"', '');
    keyUrl = _getRealUrl(keyPath);
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
}
