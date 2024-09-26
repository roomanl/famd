import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/setting/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfMaxDownNum extends GetView<SettingController> {
  const ConfMaxDownNum({super.key});

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
                    FamdLocale.maxDownTsNum.tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                  TextInfo(text: FamdLocale.maxDownTsNumTip.tr),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => {controller.changeMaxDownTsNum(-4)},
                ),
                Container(
                  width: 25,
                  alignment: Alignment.center,
                  child: Obx(
                    () => Text(controller.settingConf.value.maxDownTsNum.value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => {controller.changeMaxDownTsNum(4)},
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
