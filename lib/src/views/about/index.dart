import 'package:famd/src/common/color.dart';
import 'package:famd/src/common/config.dart';
import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/components/text/text_primary.dart';
import 'package:famd/src/controller/app.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appCtrl = Get.find<AppController>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(FamdLocale.about.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(4.0),
              child: TextInfo(
                text: '${FamdLocale.appName.tr} ${FamdLocale.channelName.tr}',
                fontSize: 16,
                opacity: 0.9,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Text('${FamdLocale.version.tr}：${appCtrl.appVersion}    '),
                  InkWell(
                    onTap: () {
                      controller.checkAppUpdate();
                    },
                    child: TextPrimary(
                      text: FamdLocale.checkUpdate.tr,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              child:
                  Text('${FamdLocale.author.tr}：${FamdLocale.authorName.tr}'),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              child: Obx(
                () => Text(
                    '${FamdLocale.ariaName.tr}${FamdLocale.version.tr}：${controller.aria2Version}'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Text('${FamdLocale.gitUrl.tr}：'),
                  InkWell(
                    onTap: () {
                      openWebUrl(FamdConfig.famdGithub);
                    },
                    child: const Text(
                      FamdConfig.famdGithub,
                      style: TextStyle(
                        color: FamdColor.colorKQL,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Text('${FamdLocale.homePage.tr}：'),
                  InkWell(
                    onTap: () {
                      openWebUrl(FamdConfig.homePage);
                    },
                    child: const Text(
                      FamdConfig.homePage,
                      style: TextStyle(
                        color: FamdColor.colorKQL,
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
}
