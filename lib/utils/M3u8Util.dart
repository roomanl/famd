import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class M3u8Util {
  //https://hd.ijycnd.com/play/Qe1PQDZd/index.m3u8
  String m3u8url = '';
  late Uri parsuri;
  late List<String> tsList = [];
  late Logger logger;
  late String IV = '';
  late String keyUrl = '';
  M3u8Util({required this.m3u8url}) {
    logger = Logger();
    // init();
  }

  init() async {
    tsList = [];
    parsuri = Uri.parse(m3u8url);
    // var res = await Dio().get(m3u8url);
    var res = await http.get(parsuri);
    logger.i(m3u8url);
    logger.i(res.statusCode);
    // logger.i(res.body);

    // logger.i(resText);
    if (res.statusCode != 200) {
      return;
    }
    String resText = res.body;
    List<String> lines = resText.split('\n');
    for (String line in lines) {
      if (line.endsWith('.ts') ||
          line.endsWith('.image') ||
          line.endsWith('.png') ||
          line.endsWith('.jpg')) {
        tsList.add(getRealUrl(line));
      } else if (line.startsWith('#EXT-X-KEY')) {
        getKey(line);
      } else if (line.contains('.m3u8')) {
        m3u8url = getRealUrl(line);
        print(m3u8url);
        init();
      }
    }
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
    print(line);
    String realUrl = '';
    if (line.startsWith('http')) {
      realUrl = line;
    } else if (line.startsWith('/')) {
      realUrl = "${parsuri.scheme}//${parsuri.host}$line";
    } else {
      int index = m3u8url.lastIndexOf("/");
      realUrl = m3u8url.substring(0, index + 1) + line;
    }
    return realUrl;
  }
}
