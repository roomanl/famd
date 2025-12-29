import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'aria2_conf_util.dart' as aria2_conf;

final Future<String> _aria2url = aria2_conf.getAria2UrlConf();
const uuid = Uuid();
final logger = Logger();

Future<String?> addUrl(params) async {
  try {
    String aria2url = await aria2_conf.getAria2UrlConf();
    var res = await http.post(Uri.parse(aria2url),
        body: json.encode({
          "jsonrpc": "2.0",
          "method": "aria2.addUri",
          "id": uuid.v4(),
          "params": params
        }));
    if (res.statusCode == 200) {
      var resJson = json.decode(res.body);
      return resJson['result'];
    }
  } catch (e) {}
  return null;
}

getAria2Version() async {
  String aria2Version = '0';
  String aria2url = await aria2_conf.getAria2UrlConf();
  try {
    var res = await http.post(Uri.parse(aria2url),
        body: json.encode({
          "jsonrpc": "2.0",
          "method": "aria2.getVersion",
          "id": 'getVersion',
          "params": []
        }));
    if (res.statusCode == 200) {
      var resJson = json.decode(res.body);
      aria2Version = resJson['result']['version'];
    }
  } catch (e) {
    print(e);
  }
  //{"id":1,"jsonrpc":"2.0","result":{"enabledFeatures":["Async DNS","BitTorrent","Firefox3 Cookie","GZip","HTTPS","Message Digest","Metalink","XML-RPC","SFTP"],"version":"1.36.0"}}
  // print(aria2Version);
  return aria2Version;
}

getSpeed() async {
  int downSpeed = 0;
  String aria2url = await aria2_conf.getAria2UrlConf();
  try {
    var res = await http.post(Uri.parse(aria2url),
        body: json.encode({
          "jsonrpc": "2.0",
          "method": "aria2.getGlobalStat",
          "id": 'getGlobalStat',
          "params": []
        }));
    if (res.statusCode == 200) {
      var resJson = json.decode(res.body);
      downSpeed = int.parse(resJson['result']['downloadSpeed']);
    }
  } catch (e) {}
  // {"id":"getGlobalStat","jsonrpc":"2.0","result":{"downloadSpeed":"0","numActive":"0","numStopped":"0","numStoppedTotal":"0","numWaiting":"0","uploadSpeed":"0"}}
  return downSpeed;
}

forcePauseAll() async {
  String aria2url = await aria2_conf.getAria2UrlConf();
  try {
    await http.post(Uri.parse(aria2url),
        body: json.encode({
          "jsonrpc": "2.0",
          "method": "aria2.forcePauseAll",
          "id": 'forcePauseAll',
          "params": []
        }));
  } catch (e) {}
}

purgeDownloadResult() async {
  String aria2url = await aria2_conf.getAria2UrlConf();
  try {
    var res = await http.post(Uri.parse(aria2url),
        body: json.encode({
          "jsonrpc": "2.0",
          "method": "aria2.purgeDownloadResult",
          "id": 'purgeDownloadResult',
          "params": []
        }));
    if (res.statusCode == 200) {
      // logger.i(res.body);
      // debugPrint(res.body);
    }
  } catch (e) {}
}

tellWaiting() async {
  String aria2url = await aria2_conf.getAria2UrlConf();
  try {
    var res = await http.post(Uri.parse(aria2url),
        body: json.encode({
          "jsonrpc": "2.0",
          "method": "aria2.tellWaiting",
          "id": 'tellWaiting',
          "params": [
            0,
            10000,
            ['gid']
          ]
        }));
    if (res.statusCode == 200) {
      return res.body;
    }
    return null;
  } catch (e) {}
}

tellStopped() async {
  String aria2url = await aria2_conf.getAria2UrlConf();
  try {
    var res = await http.post(Uri.parse(aria2url),
        body: json.encode({
          "jsonrpc": "2.0",
          "method": "aria2.tellStopped",
          "id": 'tellStopped',
          "params": [
            0,
            10000,
            ['gid']
          ]
        }));
    if (res.statusCode == 200) {
      return res.body;
    }
    return null;
  } catch (e) {}
}

tellActive() async {
  String aria2url = await aria2_conf.getAria2UrlConf();
  try {
    var res = await http.post(Uri.parse(aria2url),
        body: json.encode({
          "jsonrpc": "2.0",
          "method": "aria2.tellActive",
          "id": 'tellActive',
          "params": [
            0,
            10000,
            ['gid']
          ]
        }));
    if (res.statusCode == 200) {
      return res.body;
    }
    return null;
  } catch (e) {}
}

forceRemove(gid) async {
  String aria2url = await aria2_conf.getAria2UrlConf();
  try {
    await http.post(Uri.parse(aria2url),
        body: json.encode({
          "jsonrpc": "2.0",
          "method": "aria2.forceRemove",
          "id": 'forceRemove',
          "params": [gid]
        }));
    // if (res.statusCode == 200) {
    //   debugPrint(res.body);
    // }
  } catch (e) {}
}
