import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../common/const.dart';
import '../utils/aria2_conf_util.dart';
import '../utils/permission_util.dart';
import '../utils/setting_conf_utils.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      '下载目录',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      settingConf[SETTING_DOWN_PATH_KEY]!,
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromARGB(100, 0, 0, 0)),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  selectedDirectory(SETTING_DOWN_PATH_KEY);
                },
                child: const Text('更改'),
              ),
            ],
          ),
          const Divider(thickness: 1, height: 1),
        ],
      ),
    );
  }

  Map<String, String> settingConf = {
    SETTING_DOWN_PATH_KEY: '',
  };

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    String downPath = await getDownPath();
    setState(() {
      settingConf[SETTING_DOWN_PATH_KEY] = downPath;
    });
  }

  selectedDirectory(String key) async {
    if (Platform.isAndroid) {
      bool isGranted = await checkStoragePermission();
      if (!isGranted) {
        EasyLoading.showToast('没有权限');
        return;
      }
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      print(selectedDirectory);
      setConf(key, selectedDirectory);
      setState(() {
        settingConf[key] = selectedDirectory;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
