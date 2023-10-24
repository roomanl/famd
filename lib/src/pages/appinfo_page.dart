import 'package:flutter/material.dart';
import '../common/color.dart';
import '../common/const.dart';
import '../utils/app_update.dart';
import '../utils/ariar2_http_utils.dart';
import '../utils/common_utils.dart';

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
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: const Text('关于'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Text('版本：$appVersion    '),
                  InkWell(
                    onTap: () {
                      checkAppUpdate(context);
                    },
                    child: const Text(
                      '检查更新',
                      style: TextStyle(
                        color: KONGQUELAN,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              child: const Text('作者：怡和路恶霸'),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              child: Text('Aria2版本：$aria2Version'),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  const Text('开源地址：'),
                  InkWell(
                    onTap: () {
                      openWebUrl(FAMD_GITHUB_URL);
                    },
                    child: const Text(
                      FAMD_GITHUB_URL,
                      style: TextStyle(
                        color: KONGQUELAN,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  late String appVersion = '1.0';
  late String aria2Version = '1.0';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    String aria2 = await getVersion();
    final v = await getAppVersion();
    setState(() {
      appVersion = v;
      aria2Version = aria2;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
