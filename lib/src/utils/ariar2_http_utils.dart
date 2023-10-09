import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'aria2_conf_util.dart' as Aria2Conf;

final aria2url = Aria2Conf.getAria2UrlConf();
var uuid = Uuid();

Future<String?> addUrl(params) async {
  try {
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

getVersion() async {
  String aria2Version = '0';
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
  } catch (e) {}
  //{"id":1,"jsonrpc":"2.0","result":{"enabledFeatures":["Async DNS","BitTorrent","Firefox3 Cookie","GZip","HTTPS","Message Digest","Metalink","XML-RPC","SFTP"],"version":"1.36.0"}}
  // print(aria2Version);
  return aria2Version;
}

getSpeed() async {
  int downSpeed = 0;
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
  try {
    await http.post(Uri.parse(aria2url),
        body: json.encode({
          "jsonrpc": "2.0",
          "method": "aria2.purgeDownloadResult",
          "id": 'purgeDownloadResult',
          "params": []
        }));
  } catch (e) {}
}
