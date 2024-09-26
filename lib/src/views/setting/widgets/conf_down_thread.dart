import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/setting/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfDownThread extends GetView<SettingController> {
  const ConfDownThread({super.key});

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
                    FamdLocale.maxDownThread.tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                  TextInfo(text: FamdLocale.maxDownThreadTip.tr),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => {controller.changeMaxDownThread(-4)},
                ),
                Container(
                  width: 25,
                  alignment: Alignment.center,
                  child: Obx(
                    () =>
                        Text(controller.settingConf.value.maxDownThread.value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => {controller.changeMaxDownThread(4)},
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
