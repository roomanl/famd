import 'dart:io';

import 'package:famd/src/entity/sys_conf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../common/color.dart';
import '../common/const.dart';
import '../states/app_states.dart';
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
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      settingConf[SYS_CONF_KEY['downPath']] ?? '',
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromARGB(100, 0, 0, 0)),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  selectedDirectory(SYS_CONF_KEY['downPath']!);
                },
                child: const Text('更改'),
              ),
            ],
          ),
          const Divider(thickness: 1, height: 1),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      '主题色',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      settingConf[SYS_CONF_KEY['themeColor']] ?? '',
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromARGB(100, 0, 0, 0)),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  selectThemeColor();
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

  final _themeCtrl = Get.put(CustomThemeController());

  Map<String, String> settingConf = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    String downPath = await getDownPath();
    CustomThemeColor themeColor = await getThemeColor();
    setState(() {
      settingConf[SYS_CONF_KEY['downPath']!] = downPath;
      settingConf[SYS_CONF_KEY['themeColor']!] = themeColor.label;
    });
  }

  selectedDirectory(String key) async {
    // requestPermission();
    if (Platform.isAndroid) {
      bool isGranted = await checkStoragePermission();
      if (!isGranted) {
        EasyLoading.showToast('没有权限');
        return;
      }
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      // print(selectedDirectory);
      setConf(key, selectedDirectory);
      setState(() {
        settingConf[key] = selectedDirectory;
      });
    }
  }

  selectThemeColor() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("选择主题色"),
            children: [
              ...themeColors.map((CustomThemeColor themeColor) {
                return SimpleDialogOption(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Text(themeColor.label),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        color: themeColor.color,
                      ),
                    ],
                  ),
                  onPressed: () {
                    setConf(SYS_CONF_KEY['themeColor']!, themeColor.label);
                    _themeCtrl.updateMainColor(themeColor.color);
                    Get.changeTheme(ThemeData(
                      useMaterial3: true,
                      fontFamily: "FangYuan2",
                      colorSchemeSeed: themeColor.color,
                    ));
                    setState(() {
                      settingConf[SYS_CONF_KEY['themeColor']!] =
                          themeColor.label;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
