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
import '../common/TaskInfo.dart';
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
      getSpeed();
      updataTaskInfo();
      EventBusUtil().eventBus.fire(TaskInfoEvent(taskInfo));
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
  late TaskInfo? taskInfo = TaskInfo();

  addUrl(String url, String filename, String downPath) async {
    List params = [
      [url],
      {'out': filename, 'dir': downPath}
    ];
    EasyLoading.show(status: '添加任务中...');
    // var res = await jsonRpcClient.sendRequest('aria2.addUri', params);
    var res = await Dio().post(aria2url!, data: {
      'jsonrpc': '2.0',
      'id': 1,
      "method": 'aria2.addUri',
      "params": [
        [url],
        {'out': filename, 'dir': downPath}
      ]
    });
    EasyLoading.showSuccess('任务添加成功');
    logger.i(res);
  }

  addUrls(List<String> urls, String saveDir) async {
    List data = [];
    taskInfo = TaskInfo();
    taskInfo?.tsTotal = urls.length;
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
      TsTask tsTask = TsTask(tsName: filename, tsUrl: url);
      tsTaskList.add(tsTask);
      data.add(itemTask);
    }
    taskInfo?.tsTaskList = tsTaskList;
    EasyLoading.show(status: '添加任务中...');
    var res = await Dio().post(aria2url!, data: data);
    List<dynamic> jsonArray = jsonDecode(res.toString());
    jsonArray.asMap().forEach((index, item) {
      taskInfo?.tsTaskList?[index].gid = item['result'];
    });
    EasyLoading.showSuccess('任务添加成功');
    logger.i(taskInfo?.toString());
  }

  getSpeed() async {
    if (!online) return;
    Aria2GlobalStat data = await aria2c.getGlobalStat();
    downSpeed = data.downloadSpeed;
    taskInfo?.speed = data.downloadSpeed.toString();
    // logger.i(data.toJson());
  }

  void connection() async {
    try {
      if (!online) {
        initConf();

        aria2c = Aria2c(aria2url, "http", "");
      }
      Aria2Version version = await aria2c.getVersion();
      online = true;
      // print(version.version);
      if (online && webSocketChannel == null) {
        String url = aria2url!.replaceAll('http', 'ws');
        final wsUrl = Uri.parse(url!);
        webSocketChannel = WebSocketChannel.connect(wsUrl);
        jsonRpcClient = json_rpc.Client(webSocketChannel.cast<String>());
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
    // {"jsonrpc":"2.0","method":"aria2.onDownloadStart","params":[{"gid":"303b97964d35ebdc"}]}
    Map<String, dynamic> jsonData = jsonDecode(data);
    if (data.contains('aria2.onDown')) {
      String gid = jsonData['params'][0]['gid'];
      int taskIndex = -1;
      taskInfo?.tsTaskList?.asMap().forEach((index, item) {
        if (taskInfo?.tsTaskList?[index].gid == gid) {
          taskIndex = index;
          return;
        }
      });
      logger.i(taskIndex);
      if (taskIndex < 0) return;
      if (jsonData['method'] == 'aria2.onDownloadStart') {
        taskInfo?.tsTaskList?[taskIndex].staus = 1;
      } else if (jsonData['method'] == 'aria2.onDownloadPause') {
        taskInfo?.tsTaskList?[taskIndex].staus = 3;
      } else if (jsonData['method'] == 'aria2.onDownloadError') {
        taskInfo?.tsTaskList?[taskIndex].staus = 3;
        // logger.i('下载失败：' + jsonData['params'][0]['gid']);
      } else if (jsonData['method'] == 'aria2.onDownloadComplete') {
        taskInfo?.tsTaskList?[taskIndex].staus = 2;
        // logger.i('下载完成：' + jsonData['params'][0]['gid']);
      }
    } else if (jsonData['method'] == 'aria2.removeDownloadResult') {}
    logger.i(taskInfo.toString());
  }

  updataTaskInfo() {
    double progress = 0;
    int tsSuccess = 0;
    int tsFail = 0;
    taskInfo?.tsTaskList?.asMap().forEach((index, item) {
      TsTask? tsTask = taskInfo?.tsTaskList?[index];
      if (tsTask?.staus == 2) {
        tsSuccess++;
      } else if (tsTask?.staus == 3) {
        tsFail++;
      }
    });
    taskInfo?.tsSuccess = tsSuccess;
    taskInfo?.tsFail = tsFail;
    int tsTotal = taskInfo?.tsTotal ?? 0;
    progress = tsSuccess / tsTotal;
    taskInfo?.progress = (progress * 100).toString() + '%';
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
    var version = await aria2c.getVersion();
    return version;
  }
}
