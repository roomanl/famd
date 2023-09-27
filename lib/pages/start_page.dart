import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../common/const.dart';
import '../utils/Aria2Util.dart';
import '../utils/ConfUtil.dart';
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
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          SizedBox(
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Aria2目录',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(settingConf[ARIA2_PATH]!),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectedDirectory(ARIA2_PATH);
                  },
                  child: const Text('更改'),
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'FFmpeg目录',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(settingConf[FFMPEG_PATH]!),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectedDirectory(FFMPEG_PATH);
                  },
                  child: const Text('更改'),
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        '下载保存目录',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(settingConf[DOWN_PATH]!),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectedDirectory(DOWN_PATH);
                  },
                  child: const Text('更改'),
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            // height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Aria2服务地址',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextField(
                  // initialValue: settingConf[ARIA2_URL],
                  controller: _aria2urlcontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '请输入',
                  ),
                  onChanged: (String newText) {
                    saveAria2Url(newText);
                  },
                ),
              ],
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     selectedDirectory(DOWN_PATH);
            //   },
            //   child: const Text('更改'),
            // ),
            // ],
            // ),
          ),
          const Divider(),
          const SizedBox(height: 50),
          SizedBox(
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }

  Map<String, String> settingConf = {
    ARIA2_PATH: '',
    FFMPEG_PATH: '',
    DOWN_PATH: '',
    ARIA2_URL: '',
  };
  StreamSubscription? subscription;
  String startBtnText = '启动Aria2服务';
  final TextEditingController _aria2urlcontroller = TextEditingController();
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
    Aria2Util();
    String? aria2Path = await getAria2PathConf();
    String? ffmpegPath = await getFFmpegPathConf();
    String? downPath = await getDownPathConf();
    String? aria2url = await getAria2UrlConf();
    saveAria2Url(aria2url ?? ARIA2_URL_VALUE);
    setState(() {
      settingConf[ARIA2_PATH] = aria2Path ?? '未设置';
      settingConf[FFMPEG_PATH] = ffmpegPath ?? '未设置';
      settingConf[DOWN_PATH] = downPath ?? '未设置';
      settingConf[ARIA2_URL] = aria2url ?? ARIA2_URL_VALUE;
      _aria2urlcontroller.text = settingConf[ARIA2_URL]!;
    });
  }

  openHomePage(online) {
    setState(() {
      startBtnText = online ? 'Aria2服务已启动' : '启动Aria2服务';
    });
    if (online) {
      subscription?.cancel();
      EasyLoading.dismiss();
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
  }

  saveAria2Url(String url) {
    setAria2UrlConf(url);
    setState(() {
      settingConf[ARIA2_URL] = url;
    });
  }

  selectedDirectory(String type) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      print(selectedDirectory);
      setConf(type, selectedDirectory);
      setState(() {
        settingConf[type] = selectedDirectory;
      });
    }
  }

  startAria2() {
    if (!checkConfig()) {
      return;
    }
    EasyLoading.show(status: '启动中...');
    if (!Aria2Util().online) {
      Aria2Util().startServer();
    }

    // EasyLoading.showSuccess('配置通过');
  }

  checkConfig() {
    File aria2ExeFile = File('${settingConf[ARIA2_PATH]}/${ARIA2_EXE_NAME}');
    File aria2ConfFile = File('${settingConf[ARIA2_PATH]}/${ARIA2_CONF_NAME}');
    if (!aria2ExeFile.existsSync() || !aria2ConfFile.existsSync()) {
      EasyLoading.showInfo('aria2配置不正确');
      return false;
    }
    File ffmpegExeFile = File('${settingConf[FFMPEG_PATH]}/$FFMPGE_EXE_NAME');
    if (!ffmpegExeFile.existsSync()) {
      EasyLoading.showInfo('ffmpeg配置不正确');
      return false;
    }
    return true;
  }
}
