import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:famd/src/controller/app.dart';
import 'package:famd/src/controller/task.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import 'package:logger/logger.dart';
import 'aria2_conf_util.dart' as Aria2Conf;
import 'ariar2_http_utils.dart' as Aria2Http;
import '../common_utils.dart';

class Aria2Manager {
  static final Aria2Manager _instance = Aria2Manager._internal();
  factory Aria2Manager() => _instance;

  late final TaskController _taskCtrl;
  late final AppController _appCtrl;
  WebSocketChannel? webSocketChannel;
  late json_rpc.Client? jsonRpcClient;
  late final Logger logger;
  late Timer timer;
  late bool online;
  late final Future<String> _aria2url;
  late int downSpeed;
  late String aria2Version;
  late Future<Process> cmdProcess;
  late int processPid;
  late int timerCount;

  Aria2Manager._internal() {
    _taskCtrl = Get.find<TaskController>();
    _appCtrl = Get.find<AppController>();
    _aria2url = Aria2Conf.getAria2UrlConf();
    logger = Logger();
    online = false;
    downSpeed = 0;
    aria2Version = '0';
    processPid = 0;
    timerCount = 0;
  }
  init() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      connection();
      getSpeed();
      timerCount++;

      /// 每10S通知一次任务管理检查下载状态，是否卡住
      if (online && timerCount % 10 == 0) {
        _taskCtrl.updateAria2Notifications('check-down-status');
        timerCount = 0;
      }
    });
  }

  /// 添加下载任务
  Future<String?> addUrl(String url, String filename, String downPath) async {
    var params = [
      [url],
      {'out': filename, 'dir': downPath}
    ];
    return await Aria2Http.addUrl(params);
  }

  /// 获取下载速度
  getSpeed() async {
    if (!online) return;
    downSpeed = await Aria2Http.getSpeed();
    _appCtrl.updateAria2Speed(downSpeed);
  }

  /// 强制暂停所有下载
  forcePauseAll() async {
    await Aria2Http.forcePauseAll();
  }

  /// 清空下载结果
  purgeDownloadResult() async {
    await Aria2Http.purgeDownloadResult();
  }

  tellWaiting() async {
    await Aria2Http.tellWaiting();
  }

  cleanAria2AllTask() async {
    await Aria2Http.forcePauseAll();
    await Aria2Http.purgeDownloadResult();
    var wait = await Aria2Http.tellWaiting();
    if (wait != null) {
      var resJson = json.decode(wait);
      var list = resJson['result'];
      await forceRemove(list);
    }
    var stop = await Aria2Http.tellStopped();
    if (stop != null) {
      var resJson = json.decode(stop);
      var list = resJson['result'];
      await forceRemove(list);
    }
    var active = await Aria2Http.tellActive();
    if (active != null) {
      var resJson = json.decode(active);
      var list = resJson['result'];
      await forceRemove(list);
    }
    await clearSession();
  }

  forceRemove(list) async {
    for (Map item in list) {
      var gid = item['gid'];
      await Aria2Http.forceRemove(gid);
    }
  }

  /// 连接aria2
  void connection() async {
    var version = await Aria2Http.getAria2Version();
    if (version != '0') {
      online = true;
      if (webSocketChannel == null) {
        String aria2url = await _aria2url;
        String url = aria2url.replaceAll('http', 'ws');
        final wsUrl = Uri.parse(url);
        webSocketChannel = WebSocketChannel.connect(wsUrl);
        jsonRpcClient = json_rpc.Client(webSocketChannel!.cast<String>());
        listenWebSocket();
      }
    } else {
      debugPrint('aria2连接失败');
      online = false;
      jsonRpcClient = null;
      webSocketChannel = null;
    }
    _appCtrl.updateAria2Online(online);
  }

  /// 监听websocket
  listenWebSocket() {
    webSocketChannel?.stream.listen((data) {
      // logger.i(data);
      listNotifications(data);
    }, onError: (error) {
      logger.e(error);
    });
  }

  /// 监听通知
  listNotifications(String data) {
    _taskCtrl.updateAria2Notifications(data);
  }

  /// 启动aria2服务
  void startServer() async {
    closeServer();
    var exe = await Aria2Conf.getAria2ExePath();
    // debugPrint(exe);
    var conf = await Aria2Conf.getAria2ConfPath();
    // debugPrint(conf);
    // debugPrint(File(conf).existsSync());
    if (Platform.isLinux) {
      permission777(exe);
      permission777(conf);
    }
    debugPrint('开始启动服务');
    cmdProcess = Process.start(exe, ['--conf-path=$conf']);
    cmdProcess.then((processResult) {
      debugPrint(processResult.pid.toString());
      processPid = processResult.pid;
      processResult.exitCode.then((value) => debugPrint('exitCode:$value'));
      processResult.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        if (line.trim().isNotEmpty) {
          //logger.i(line);
        }
      });
      processResult.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        if (line.trim().isNotEmpty) {
          //logger.i("Error: $line");
        }
      });
    });
  }

  /// 初始化aria2配置
  initAria2Conf() async {
    await Aria2Conf.initAria2Conf();
  }

  /// 清空aria2配置
  clearSession() async {
    await Aria2Conf.clearSession();
  }

  /// 关闭aria2服务
  closeServer() {
    debugPrint('开始关闭服务');
    bool killSuccess = false;
    try {
      if (Platform.isWindows) {
        final processResult =
            Process.runSync('taskkill', ['/F', '/T', '/IM', 'm3u8aria2c.exe']);
        killSuccess = processResult.exitCode == 0;
      } else if (Platform.isLinux || Platform.isAndroid) {
        final processResult = Process.runSync('killall', ['m3u8aria2c']);
        killSuccess = processResult.exitCode == 0;
      }
    } catch (e) {
      logger.e(e);
    }
    online = false;
    debugPrint('关闭服务:$killSuccess');
  }
}
