import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:path_provider/path_provider.dart';
import '../common/const.dart';
import '../states/app_states.dart';
import '../utils/aria2_manager.dart';
import '../utils/native_channel_utils.dart';
import './home_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 150,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(mainColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                elevation: MaterialStateProperty.all(20),
                shape: MaterialStateProperty.all(
                  const CircleBorder(),
                )),
            onPressed: () {
              startAria2();
            },
            child: Text(
              startBtnText,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  final _appCtrl = Get.put(AppController());
  late int count = 0;
  late bool isStartServer = false;
  String startBtnText = '启动Aria2服务';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    appStatesListener();
    Aria2Manager().initAria2Conf();
    startAria2();
    // String path = await getAria2SoPath();
    // print('=====================>' + path);
    // String aa = await rootBundle.loadString("lib/resources/aria2.conf");
    // print('=====================>' + aa);
  }

  appStatesListener() {
    _appCtrl.aria2Online.listen((val) {
      if (!mounted) return;
      openHomePage(val);
    });
  }

  openHomePage(online) {
    if (isStartServer) {
      count++;
    }
    if (online) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else if (isStartServer && count > 20) {
      ///监听aria2服务状态，20S内没监听到aria2服务在线判定为启动失败
      setState(() {
        startBtnText = '启动失败!';
      });
      isStartServer = false;
      count = 0;
    }
  }

  startAria2() {
    if (isStartServer) {
      return;
    }
    if (!Aria2Manager().online) {
      setState(() {
        startBtnText = 'Aria2启动中...';
      });
      isStartServer = true;
      Aria2Manager().startServer();
    }
  }
}
