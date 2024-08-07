import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:famd/src/controller/app.dart';
import 'package:get/instance_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import 'package:logger/logger.dart';
import '../../view_models/app_states.dart';
import 'aria2_conf_util.dart' as Aria2Conf;
import 'ariar2_http_utils.dart' as Aria2Http;
import '../common_utils.dart';

class Aria2Manager {
  static final Aria2Manager _instance = Aria2Manager._internal();
  factory Aria2Manager() => _instance;

  final _appCtrl2 = Get.put(AppController2());
  final _taskCtrl = Get.put(TaskController());
  final _appCtrl = Get.find<AppController>();
  WebSocketChannel? webSocketChannel;
  json_rpc.Client? jsonRpcClient;
  late Logger logger = Logger();
  late Timer timer;
  late bool online = false;
  late final Future<String> _aria2url = Aria2Conf.getAria2UrlConf();
  late int downSpeed = 0;
  late String aria2Version = '0';
  late Future<Process> cmdProcess;
  late int processPid = 0;
  late int timerCount = 0;

  Aria2Manager._internal() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      connection();
      getSpeed();
      timerCount++;

      /// 每10S通知一次任务管理检查下载状态，是否卡住
      if (online && timerCount % 10 == 0) {
        _taskCtrl.updateAria2Notifications('check-down-status');
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
    _appCtrl2.updateAria2Speed(downSpeed);
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

  /// 连接aria2
  void connection() async {
    var version = await Aria2Http.getVersion();
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
      print('aria2连接失败');
      online = false;
      jsonRpcClient = null;
      webSocketChannel = null;
    }
    _appCtrl2.updateAria2Online(online);
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
    // print(exe);
    var conf = await Aria2Conf.getAria2ConfPath();
    // print(conf);
    // print(File(conf).existsSync());
    if (Platform.isLinux) {
      permission777(exe);
      permission777(conf);
    }
    print('开始启动服务');
    cmdProcess = Process.start(exe, ['--conf-path=$conf']);
    cmdProcess.then((processResult) {
      print(processResult.pid);
      processPid = processResult.pid;
      processResult.exitCode.then((value) => print(value));
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
  clearSession() {
    Aria2Conf.clearSession();
  }

  /// 关闭aria2服务
  closeServer() {
    print('开始关闭服务');
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
    print('关闭服务:' + killSuccess.toString());
  }
}
