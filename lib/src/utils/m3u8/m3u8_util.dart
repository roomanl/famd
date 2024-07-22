import 'package:famd/src/entity/m3u8_task.dart';
import 'package:famd/src/entity/ts_info.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class M3u8Util {
  //https://hd.ijycnd.com/play/Qe1PQDZd/index.m3u8
  late M3u8Task task;
  String m3u8url = '';
  late Uri parsuri;
  late List<TsInfo> tsList = [];
  late Logger logger;
  late String IV = '';
  late String keyUrl = '';
  M3u8Util({required this.m3u8url}) {
    logger = Logger();
    // init();
  }

  parse() async {
    tsList = [];
    parsuri = Uri.parse(m3u8url);
    // var res = await Dio().get(m3u8url);
    var res = await http.get(parsuri);
    // logger.i(m3u8url);
    // logger.i(res.statusCode);
    // logger.i(res.body);
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
        TsInfo tsInfo =
            TsInfo(pid: task.getId!, tsurl: line, filename: filename);
        tsList.add(tsInfo);
        insertTsInfo(tsInfo);
      } else if (line.startsWith('#EXT-X-KEY')) {
        getKey(line);
      } else if (line.contains('.m3u8')) {
        m3u8url = getRealUrl(line);
        // print(m3u8url);
        return parse();
      }
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
    this.task = task;
    List<TsInfo> tsList = await getTsListByPid(task.getId!);
    m3u8url = task.getM3u8url;
    if (tsList.isEmpty || (task.getKeyurl != null && task.getIv == null)) {
      deleteTsByPid(task.getId!);
      logger.i('开始解析M3U8！');
      return parse();
    }
    logger.i('已经解析过M3U8，跳过解析！');
    this.tsList = tsList;
    IV = task.getIv!;
    keyUrl = task.getKeyurl!;
    return true;
  }

  getKey(String line) {
    List<String> lines = line.split(',');
    if (lines.length > 2) {
      IV = lines[2].split('=')[1];
    }
    String keyPath = lines[1].split('=')[1].replaceAll('"', '');
    keyUrl = getRealUrl(keyPath);
    // logger.i(IV);
    // logger.i(keyUrl);
  }

  getRealUrl(line) {
    // print(line);
    String realUrl = '';
    if (line.startsWith('http')) {
      realUrl = line;
    } else if (line.startsWith('/')) {
      realUrl = "${parsuri.scheme}://${parsuri.host}$line";
    } else {
      int index = m3u8url.lastIndexOf("/");
      realUrl = m3u8url.substring(0, index + 1) + line;
    }
    return realUrl.trim();
  }
}
