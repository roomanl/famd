import 'package:famd/src/controller/app.dart';
import 'package:famd/src/views/setting/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfDownFolderWidget extends GetView<SettingController> {
  const ConfDownFolderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appCtrl = Get.find<AppController>();
    return GetBuilder<SettingController>(
      builder: (_) {
        return Row(
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
                  Obx(
                    () => Text(
                      controller.settingConf.value.downPath.value,
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromARGB(100, 0, 0, 0)),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.selectedDirectory();
              },
              child: const Text('更改'),
            ),
          ],
        );
      },
    );
  }
}
