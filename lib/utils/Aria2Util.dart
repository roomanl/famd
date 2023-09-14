import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:aria2/aria2.dart';
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
      getSpeed();
    });
  }

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
    var res = await Dio().post(aria2url!, data: {
      'jsonrpc': '2.0',
      'id': 'flutter',
      "method": 'aria2.addUri',
      "params": params
    });
    EasyLoading.showSuccess('任务添加成功');
    logger.i(res);
  }

  addUrls(List<String> urls, String saveDir) async {
    List data = [];
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
      data.add(itemTask);
    }
    EasyLoading.show(status: '添加任务中...');
    var res = await Dio().post(aria2url!, data: data);
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
        aria2c = Aria2c(aria2url, "http", "");
      }
      Aria2Version version = await aria2c.getVersion();
      online = true;
      // print(version.version);
    } catch (e) {
      online = false;
    }
    EventBusUtil().eventBus.fire(Aria2ServerEvent(online));
    // print('online:' + online.toString());
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
    // print(123);
    // process.stdout.transform(utf8.decoder).listen((data) {
    //   output += data;
    // });
    // process.exitCode.then((exitCode) {
    //   if (exitCode == 0) {
    //     print('命令执行成功：$output');
    //   } else {
    //     print('命令执行失败：$exitCode');
    //   }
    // });
    print(process.stdout);
    print(process.exitCode);
    print(process.pid);
    print(process.stderr);
    // process.stdout.transform(utf8.decoder).listen((data) {
    //   output += data;
    // });
  }

  getVersion() async {
    Aria2Version version = await aria2c.getVersion();
    return version.version;
  }
}
