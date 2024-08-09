import 'package:famd/src/components/text/text_primary.dart';
import 'package:famd/src/controller/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appCtrl = Get.find<AppController>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  Text('版本：${appCtrl.appVersion}    '),
                  InkWell(
                    onTap: () {
                      controller.checkAppUpdate();
                    },
                    child: const TextPrimary(
                      text: '检查更新',
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
}
