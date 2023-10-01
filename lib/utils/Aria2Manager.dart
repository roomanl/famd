import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:aria2/aria2.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import 'package:logger/logger.dart';
import '../entity/TaskInfo.dart';
import 'Aria2ConfUtil.dart' as Aria2Conf;
import 'EventBusUtil.dart';
import 'FileUtils.dart';

class Aria2Manager {
  // 私有静态变量，用于保存单例实例
  static final Aria2Manager _instance = Aria2Manager._internal();

  // 工厂构造方法，返回单例实例
  factory Aria2Manager() => _instance;

  // 私有构造方法，防止外部实例化
  Aria2Manager._internal() {
    logger = Logger();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      connection();
      getSpeed();
    });
  }

// final WebSocketManager _webSocketManager = WebSocketManager();
  var webSocketChannel = null;
  var jsonRpcClient = null;
  late Logger logger;
  late Timer timer;
  late Aria2c aria2c;
  late bool online = false;
  late String aria2url = Aria2Conf.getAria2UrlConf();
  late int? downSpeed;
  late Future<Process> cmdProcess;
  late int processPid = 0;
  var uuid = Uuid();

  Future<Response> addUrl(String url, String filename, String downPath) async {
    // var res = await jsonRpcClient.sendRequest('aria2.addUri', params);
    var res = await Dio().post(
      aria2url,
      data: {
        'jsonrpc': '2.0',
        'id': uuid.v4(),
        "method": 'aria2.addUri',
        "params": [
          [url],
          {'out': filename, 'dir': downPath}
        ]
      },
      options: Options(
        headers: {
          // Set the content-length.
        },
      ),
    );
    return res;
  }

  addUrls(List<String> urls, String saveDir) async {
    List data = [];
    List<TsTask>? tsTaskList = [];
    for (int i = 0; i < urls.length; i++) {
      String url = urls[i];
      String filename = i.toString().padLeft(4, '0') + '.ts';
      Map itemTask = {
        'jsonrpc': '2.0',
        'id': i,
        "method": 'aria2.addUri',
        "params": [
          [url],
          {'out': filename, 'dir': saveDir}
        ]
      };
      TsTask tsTask = TsTask(tsName: filename, tsUrl: url, savePath: saveDir);
      tsTaskList.add(tsTask);
      data.add(itemTask);
    }
    var res = await Dio().post(aria2url, data: data);
    List<dynamic> jsonArray = jsonDecode(res.toString());
    jsonArray.asMap().forEach((index, item) {
      tsTaskList[index].gid = item['result'];
    });
    return tsTaskList;
  }

  getSpeed() async {
    if (!online) return;
    Aria2GlobalStat data = await aria2c.getGlobalStat();
    downSpeed = data.downloadSpeed;
  }

  void connection() async {
    try {
      if (!online) {
        aria2c = Aria2c(aria2url, "http", "");
      }
      // print(aria2url);
      await aria2c.getVersion();
      online = true;
      // print(version.version);
      if (online && webSocketChannel == null) {
        String url = aria2url.replaceAll('http', 'ws');
        final wsUrl = Uri.parse(url);
        webSocketChannel = WebSocketChannel.connect(wsUrl);
        jsonRpcClient = json_rpc.Client(webSocketChannel.cast<String>());
        listenWebSocket();
      }
    } catch (e) {
      // logger.e(e);
      print('aria2连接失败');
      online = false;
    }
    if (!online) {
      jsonRpcClient = null;
      webSocketChannel = null;
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

  listNotifications(String data) {
    EventBusUtil().eventBus.fire(ListAria2Notifications(data));
  }

  void startServer() {
    closeServer();
    var exe = Aria2Conf.getAria2ExePath();
    var conf = '--conf-path=${Aria2Conf.getAria2ConfPath()}';

    // var exe = ARIA2_EXE_NAME;
    // var conf = '--conf-path=$ARIA2_CONF_NAME';
    cmdProcess = Process.start(exe, [conf],
        workingDirectory: Aria2Conf.getAria2rootPath());
    cmdProcess.then((processResult) {
      print(processResult.pid);
      processPid = processResult.pid;
      processResult.exitCode.then((value) => print(value));
      processResult.stdout
          .transform(utf8.decoder)
          .transform(LineSplitter())
          .listen((event) {
        if (event.trim().isNotEmpty) {
          logger.i(event);
        }
      });
      processResult.stderr
          .transform(utf8.decoder)
          .transform(LineSplitter())
          .listen((event) {
        if (event.trim().isNotEmpty) {
          logger.i("Error: $event");
        }
      });
    });
  }

  initAria2Conf() {
    Aria2Conf.initAria2Conf();
  }

  clearSession() {
    Aria2Conf.clearSession();
  }

  closeServer() {
    print('开始关闭服务');
    // bool killSuccess = Process.killPid(processPid);
    final processResult =
        Process.runSync('taskkill', ['/F', '/T', '/IM', 'm3u8aria2c.exe']);
    print('关闭服务:' + processResult.exitCode.toString());
  }

  getVersion() async {
    var version = await aria2c.getVersion();
    return version;
  }
}
