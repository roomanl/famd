import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:get/instance_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import 'package:logger/logger.dart';
import '../states/app_states.dart';
import 'aria2_conf_util.dart' as Aria2Conf;
import 'ariar2_http_utils.dart' as Aria2Http;
import 'common_utils.dart';
import 'event_bus_util.dart';

class Aria2Manager {
  static final Aria2Manager _instance = Aria2Manager._internal();
  factory Aria2Manager() => _instance;

  final _appCtrl = Get.put(AppController());
  var webSocketChannel = null;
  var jsonRpcClient = null;
  late Logger logger = Logger();
  late Timer timer;
  late bool online = false;
  late Future<String> _aria2url = Aria2Conf.getAria2UrlConf();
  late int downSpeed = 0;
  late String aria2Version = '0';
  late Future<Process> cmdProcess;
  late int processPid = 0;
  var uuid = Uuid();
  late int timerCount = 0;

  Aria2Manager._internal() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      connection();
      getSpeed();
      timerCount++;

      /// 每10S通知一次任务管理检查下载状态，是否卡住
      if (online && timerCount % 10 == 0) {
        EventBusUtil()
            .eventBus
            .fire(ListAria2Notifications('check-down-status'));
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
        jsonRpcClient = json_rpc.Client(webSocketChannel.cast<String>());
        listenWebSocket();
      }
    } else {
      print('aria2连接失败');
      online = false;
      jsonRpcClient = null;
      webSocketChannel = null;
    }
    _appCtrl.updateAria2Online(online);
    // EventBusUtil().eventBus.fire(Aria2ServerEvent(online));
  }

  /// 监听websocket
  listenWebSocket() {
    webSocketChannel.stream.listen((data) {
      // logger.i(data);
      listNotifications(data);
    }, onError: (error) {
      logger.e(error);
    });
  }

  /// 监听通知
  listNotifications(String data) {
    EventBusUtil().eventBus.fire(ListAria2Notifications(data));
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

    cmdProcess = Process.start(exe, ['--conf-path=$conf']);
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

/**
   * 初始化aria2配置
   */
  initAria2Conf() async {
    await Aria2Conf.initAria2Conf();
  }

/**
   * 清空aria2配置
   */
  clearSession() {
    Aria2Conf.clearSession();
  }

/**
   * 关闭aria2服务
   */
  closeServer() {
    print('开始关闭服务');
    bool killSuccess = false;
    if (Platform.isWindows) {
      final processResult =
          Process.runSync('taskkill', ['/F', '/T', '/IM', 'm3u8aria2c.exe']);
      killSuccess = processResult.exitCode == 0;
    } else if (Platform.isLinux || Platform.isAndroid) {
      final processResult = Process.runSync('killall', ['m3u8aria2c']);
      killSuccess = processResult.exitCode == 0;
    }
    print('关闭服务:' + killSuccess.toString());
  }
}

  // addUrls(List<String> urls, String saveDir) async {
  //   List data = [];
  //   List<TsTask>? tsTaskList = [];
  //   for (int i = 0; i < urls.length; i++) {
  //     String url = urls[i];
  //     String filename = i.toString().padLeft(4, '0') + '.ts';
  //     Map itemTask = {
  //       'jsonrpc': '2.0',
  //       'id': i,
  //       "method": 'aria2.addUri',
  //       "params": [
  //         [url],
  //         {'out': filename, 'dir': saveDir}
  //       ]
  //     };
  //     TsTask tsTask = TsTask(tsName: filename, tsUrl: url, savePath: saveDir);
  //     tsTaskList.add(tsTask);
  //     data.add(itemTask);
  //   }
  //   var res = await Dio().post(aria2url, data: data);
  //   List<dynamic> jsonArray = jsonDecode(res.toString());
  //   jsonArray.asMap().forEach((index, item) {
  //     tsTaskList[index].gid = item['result'];
  //   });
  //   return tsTaskList;
  // }
