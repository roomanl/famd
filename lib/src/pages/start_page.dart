import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/Aria2Manager.dart';
import '../utils/EventBusUtil.dart';
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
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 53, 188, 174)),
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }

  late int count = 0;
  late bool isStartServer = false;
  StreamSubscription? subscription;
  String startBtnText = '启动Aria2服务';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    subscription =
        EventBusUtil().eventBus.on<Aria2ServerEvent>().listen((event) {
      openHomePage(event.online);
    });
    Aria2Manager().initAria2Conf();
    startAria2();
  }

  openHomePage(online) {
    if (isStartServer) {
      count++;
    }
    if (online) {
      subscription?.cancel();
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else if (isStartServer && count > 10) {
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
