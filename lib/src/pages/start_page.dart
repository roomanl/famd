import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import '../common/const.dart';
import '../states/app_states.dart';
import '../utils/aria2_manager.dart';
import '../utils/common_utils.dart';
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: _themeCtrl.mainColor.value, //
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Famd M3u8下载器',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 36),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(_themeCtrl.mainColor.value),
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
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'V $appVersion',
                    style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                        fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _appCtrl = Get.put(AppController());
  final _themeCtrl = Get.put(CustomThemeController());
  late int count = 0;
  late bool isStartServer = false;
  String startBtnText = '启动Aria2服务';
  late String appVersion = '1.0';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appCtrl
        .updateShowNavigationDrawer(MediaQuery.of(context).size.width <= 500);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    final v = await getAppVersion();
    setState(() {
      appVersion = v;
    });
    appStatesListener();
    await Aria2Manager().initAria2Conf();
    startAria2();
    // openHomePage(true);
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

  startAria2() async {
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
