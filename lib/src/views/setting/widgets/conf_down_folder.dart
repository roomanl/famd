import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/setting/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfDownFolderWidget extends GetView<SettingController> {
  const ConfDownFolderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      builder: (_) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    FamdLocale.downDir.tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Obx(
                    () => TextInfo(
                      text: controller.settingConf.value.downPath.value,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.selectedDirectory();
              },
              child: Text(FamdLocale.change.tr),
            ),
          ],
        );
      },
    );
  }
}
