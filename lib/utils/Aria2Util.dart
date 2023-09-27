import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:aria2_m3u8/utils/FfmpegUtil.dart';
import 'package:aria2_m3u8/utils/WebSocketManager.dart';
import 'package:dio/dio.dart';
import 'package:aria2/aria2.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import '../entity/M3u8Task.dart';
import '../entity/TaskInfo.dart';
import 'ASEUtil.dart';
import 'ConfUtil.dart';
import 'EventBusUtil.dart';
import 'M3u8Util.dart';
import '../common/const.dart';
import 'TaskPrefsUtil.dart';

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
      if (isDowning) {
        getSpeed();
        EventBusUtil().eventBus.fire(TaskInfoEvent(taskInfo));
      }
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
  late M3u8Task tasking;
  late bool isDowning = false;
  late bool isDecryptTsing = false;
  late Future<Process> cmdProcess;
  late int processPid = 0;

  startAria2Task(M3u8Task task) async {
    if (isDowning) return;
    isDowning = true;
    tasking = task;
    EasyLoading.show(status: '正在开始任务...');
    String? downPath = await getDownPathConf();
    M3u8Util m3u8 = M3u8Util(m3u8url: task.m3u8url);
    await m3u8.init();
    task.iv = m3u8.IV;
    task.keyurl = m3u8.keyUrl;
    task.downdir = downPath;
    task.status = 2;

    List<String> tsList = m3u8.tsList;
    logger.i(tsList);
    //[m3u8.tsList[0], m3u8.tsList[1]];
    String saveDir = getTsSaveDir(task, downPath);
    await Aria2Util().addUrls(tsList, saveDir);
    await updateM3u8Task(task);
    EasyLoading.showSuccess('任务启动成功');
  }

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
      TsTask tsTask = TsTask(tsName: filename, tsUrl: url, savePath: saveDir);
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
    // logger.i(taskInfo?.toString());
  }

  getSpeed() async {
    if (!online) return;
    Aria2GlobalStat data = await aria2c.getGlobalStat();
    downSpeed = data.downloadSpeed;
    taskInfo?.speed = bytesToSize(data.downloadSpeed);
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
      // logger.i(taskIndex);
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
      updataTaskInfo();
    } else if (jsonData['method'] == 'aria2.removeDownloadResult') {}
    // logger.i(taskInfo.toString());
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
    taskInfo?.progress =
        tsTotal == 0 ? '0%' : (progress * 100).toStringAsFixed(2) + '%';

    if (tsSuccess + tsFail == tsTotal) {
      if (tsFail > 0) {
      } else {
        decryptTs();
      }
    }
  }

  decryptTs() async {
    if (!isDowning && isDecryptTsing) return;
    isDecryptTsing = true;
    EasyLoading.showInfo('开始解密ts文件');
    String? downPath = await getDownPathConf();
    List<String> decryptTsList = [];
    if (!tasking.keyurl!.isEmpty) {
      final keystr = await Dio().get(tasking.keyurl!);
      taskInfo?.tsTaskList?.asMap().forEach((index, item) async {
        TsTask? tsTask = taskInfo?.tsTaskList?[index];
        String tsPath = '${getTsSaveDir(tasking, downPath)}/${tsTask!.tsName}';
        String tsSavePath =
            '${getDtsSaveDir(tasking, downPath)}/${tsTask.tsName}';
        bool decryptSuccess =
            aseDecryptTs(tsPath, tsSavePath, keystr.toString(), tasking.iv);
        if (decryptSuccess) {
          taskInfo?.tsDecrty++;
          decryptTsList.add('file \'$tsSavePath\'');
        }
        EventBusUtil().eventBus.fire(TaskInfoEvent(taskInfo));
      });
    } else {
      taskInfo?.tsTaskList?.asMap().forEach((index, item) async {
        TsTask? tsTask = taskInfo?.tsTaskList?[index];
        String tsPath = '${getTsSaveDir(tasking, downPath)}/${tsTask!.tsName}';
        decryptTsList.add('file \'$tsPath\'');
      });
    }
    String fileListPath =
        '$downPath/${tasking.m3u8name}/${tasking.subname}/file.txt';
    // logger.i(fileListPath);
    File(fileListPath).writeAsStringSync(decryptTsList.join('\n'), flush: true);
    EasyLoading.showInfo('解密完成');
    // mergeTs(downPath, fileListPath);
  }

  mergeTs(downPath, fileListPath) {
    EasyLoading.showInfo('开始合并ts文件');
    taskInfo?.mergeStatus = '合并中';
    EventBusUtil().eventBus.fire(TaskInfoEvent(taskInfo));
    String mp4Path =
        '$downPath/${tasking.m3u8name}/${tasking.m3u8name}-${tasking.subname}.mp4';
    tsMergeTs(fileListPath, mp4Path, () {
      taskInfo?.mergeStatus = '合并完成';
      EasyLoading.showInfo('合并成功');
      tasking.status = 3;
      updateM3u8Task(tasking);

      try {
        String folderPath = '$downPath/${tasking.m3u8name}/${tasking.subname}';
        Directory directory = Directory(folderPath);
        directory.deleteSync(recursive: true);
      } catch (e) {
        logger.e(e);
      }
      downReset();
      EventBusUtil().eventBus.fire(DownSuccessEvent());
    });
  }

  downReset() {
    isDowning = false;
    isDecryptTsing = false;
  }

  void initConf() async {
    aria2Path ??= await getAria2PathConf();
    aria2url ??= await getAria2UrlConf();
    // downPath ??= await getAria2UrlConf(DOWN_PATH);
  }

  void startServer() {
    var exe = '$aria2Path/$ARIA2_EXE_NAME';
    var conf = '--conf-path=$aria2Path/$ARIA2_CONF_NAME';
    cmdProcess = Process.start('cmd', ['/c', exe, conf]);
    cmdProcess.then((processResult) {
      print(processResult.pid);
      processPid = processResult.pid;
      // processResult.exitCode.then((value) => print(value));
      // processResult.stdout
      //     .transform(utf8.decoder)
      //     .transform(LineSplitter())
      //     .listen((event) {
      //   logger.i("child: $event");
      // });
      // processResult.stderr
      //     .transform(utf8.decoder)
      //     .transform(LineSplitter())
      //     .listen((event) {
      //   logger.i("child Error: $event");
      // });
    });
  }

  void closeServer() {
    print('开始关闭服务');
    // bool killSuccess = Process.killPid(processPid);
    final processResult =
        Process.runSync('taskkill', ['/F', '/T', '/PID', '$processPid']);
    print('关闭服务:' + processResult.exitCode.toString());
  }

  String getTsSaveDir(M3u8Task task, String? downPath) {
    // String? downPath = await findSysConfigByName(DOWN_PATH);
    String saveDir = '$downPath/${task.m3u8name}/${task.subname}/ts';
    Directory directory = Directory(saveDir);
    if (!directory.existsSync()) {
      directory.create(recursive: true);
    }
    return saveDir;
  }

  String getDtsSaveDir(M3u8Task task, String? downPath) {
    // String? downPath = await findSysConfigByName(DOWN_PATH);
    String saveDir = '$downPath/${task.m3u8name}/${task.subname}/dts';
    Directory directory = Directory(saveDir);
    if (!directory.existsSync()) {
      directory.create(recursive: true);
    }
    return saveDir;
  }

  getVersion() async {
    var version = await aria2c.getVersion();
    return version;
  }

  bytesToSize(bytes) {
    if (bytes == 0) return '0 B';
    var k = 1024;
    var sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    var i = (log(bytes) / log(k)).floor();
    return (bytes / pow(k, i)).toStringAsFixed(2) + ' ' + sizes[i];
  }
}
