import 'package:file_picker/file_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import '../common/const.dart';
import '../utils/SettingConfUtils.dart';

class AppinfoPage extends StatefulWidget {
  const AppinfoPage({super.key});

  @override
  _AppinfoPageState createState() => _AppinfoPageState();
}

class _AppinfoPageState extends State<AppinfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('关于'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('版本：$appVersion'),
            const Text('作者：怡和路恶霸'),
            const Text('开源地址：https://github.com/roomanl/famd'),
          ],
        ),
      ),
    );
  }

  late String appVersion = '1.0';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
