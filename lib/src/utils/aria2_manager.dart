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
  late String aria2url = Aria2Conf.getAria2UrlConf();
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

      /// 下载完一个TS后才会触发ListAria2Notifications广播
      /// 有极小的概率TS下载完后没有触发ListAria2Notifications广播
      /// TS下载完却没有触发ListAria2Notifications广播，会导致软件卡住
      /// 这里设置每30秒主动触发一次ListAria2Notifications广播，防止软件卡住
      if (online && timerCount % 30 == 0) {
        EventBusUtil().eventBus.fire(ListAria2Notifications('check-ts-um'));
      }
    });
  }

  Future<String?> addUrl(String url, String filename, String downPath) async {
    var params = [
      [url],
      {'out': filename, 'dir': downPath}
    ];
    return await Aria2Http.addUrl(params);
  }

  getSpeed() async {
    if (!online) return;
    downSpeed = await Aria2Http.getSpeed();
  }

  forcePauseAll() async {
    await Aria2Http.forcePauseAll();
  }

  purgeDownloadResult() async {
    await Aria2Http.purgeDownloadResult();
  }

  void connection() async {
    var version = await Aria2Http.getVersion();
    if (version != '0') {
      online = true;
      if (webSocketChannel == null) {
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
