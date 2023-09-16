import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:aria2_m3u8/utils/WebSocketManager.dart';
import 'package:dio/dio.dart';
import 'package:aria2/aria2.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'EventBusUtil.dart';
import '../DB/server/SysConfigServer.dart';
import '../common/const.dart';

class Aria2Util {
  // 私有静态变量，用于保存单例实例
  static final Aria2Util _instance = Aria2Util._internal();

  // 工厂构造方法，返回单例实例
  factory Aria2Util() => _instance;

  // 私有构造方法，防止外部实例化
  Aria2Util._internal() {
    logger = Logger();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      connection();
      // getSpeed();
    });
  }

// final WebSocketManager _webSocketManager = WebSocketManager();
  var webSocketChannel = null;
  var jsonRpcClient = null;
  late Logger logger;
  late Timer timer;
  late Aria2c aria2c;
  late bool online = false;
  late String? aria2url = null;
  // late String? downPath = null;
  late String? aria2Path = null;
  late int? downSpeed;

  addUrl(String url, String filename, String downPath) async {
    List params = [
      [url],
      {'out': filename, 'dir': downPath}
    ];
    EasyLoading.show(status: '添加任务中...');
    var res = await jsonRpcClient.sendRequest('aria2.addUri', params);
    EasyLoading.showSuccess('任务添加成功');
    logger.i(res);
  }

  addUrls(List<String> urls, String saveDir) async {
    List data = [];
    for (int i = 0; i < urls.length; i++) {
      String url = urls[i];
      String filename = i.toString().padLeft(4, '0') + '.ts';
      Map itemTask = {
        // 'jsonrpc': '2.0',
        // 'id': i,
        "method": 'aria2.addUri',
        "params": [
          [url],
          {'out': filename, 'dir': saveDir}
        ]
      };
      data.add(itemTask);
    }
    EasyLoading.show(status: '添加任务中...');
    var res = await jsonRpcClient.sendRequest('aria2.addUri', [data]);
    // var res = await Dio().post(aria2url!, data: data);
    EasyLoading.showSuccess('任务添加成功');
    logger.i(res);
  }

  getSpeed() async {
    if (!online) return;
    Aria2GlobalStat data = await aria2c.getGlobalStat();
    downSpeed = data.downloadSpeed;
    // logger.i(data.toJson());
  }

  void connection() async {
    try {
      if (!online) {
        initConf();
        String httpurl = aria2url!.replaceAll('ws', 'http');
        aria2c = Aria2c(httpurl, "http", "");
      }
      Aria2Version version = await aria2c.getVersion();
      online = true;
      // print(version.version);
      if (online && webSocketChannel == null) {
        final wsUrl = Uri.parse(aria2url!);
        webSocketChannel = WebSocketChannel.connect(wsUrl);
        // WebSocketManager _webSocketManager = WebSocketManager();
        // _webSocketManager.connect(aria2url!);
        // webSocketChannel = _webSocketManager.getWebSocketChannel();
        logger.i(webSocketChannel);
        jsonRpcClient = json_rpc.Client(webSocketChannel.cast<String>());
        logger.i(jsonRpcClient);
        listenWebSocket();
      }
    } catch (e) {
      logger.e(e);
      online = false;
    }
    if (!online) {
      jsonRpcClient = null;
      webSocketChannel = null;
    }
    try {
      var v = await getVersion();
      logger.i(v);
    } catch (e) {
      logger.e(e);
    }
    EventBusUtil().eventBus.fire(Aria2ServerEvent(online));
    // print('online:' + online.toString());
  }

  listenWebSocket() {
    webSocketChannel.stream.listen((data) {
      // logger.i(data);
      listNotifications(data);
    }, onError: (error) {
      logger.e(error);
    });
  }

  listNotifications(data) {
    //{"jsonrpc":"2.0","method":"aria2.onDownloadStart","params":[{"gid":"303b97964d35ebdc"}]}
    Map<String, dynamic> jsonData = jsonDecode(data);
    if (jsonData['method'] == 'aria2.onDownloadStart') {
    } else if (jsonData['method'] == 'aria2.onDownloadPause') {
    } else if (jsonData['method'] == 'aria2.onDownloadError') {
      logger.i('下载失败：' + jsonData['params'][0]['gid']);
    } else if (jsonData['method'] == 'aria2.onDownloadComplete') {
      logger.i('下载完成：' + jsonData['params'][0]['gid']);
    } else if (jsonData['method'] == 'aria2.removeDownloadResult') {}
  }

  void initConf() async {
    aria2Path ??= await findSysConfigByName(ARIA2_PATH);
    aria2url ??= await findSysConfigByName(ARIA2_URL);
    // downPath ??= await findSysConfigByName(DOWN_PATH);
  }

  void startServer() async {
    var exe = '${aria2Path}/${ARIA2_EXE_NAME}';
    var conf = '--conf-path=${aria2Path}/aria2.conf';
    var output = ''; // 命令输出结果

    var process = await Process.run('cmd', ['/c', exe, conf]);
    print(process.stdout);
    print(process.exitCode);
    print(process.pid);
    print(process.stderr);
  }

  getVersion() async {
    if (jsonRpcClient == null) return null;
    try {
      var version = await jsonRpcClient.sendRequest('aria2.getVersion', []);
    } catch (e) {
      logger.e(e);
    }
    return null;
  }
}
