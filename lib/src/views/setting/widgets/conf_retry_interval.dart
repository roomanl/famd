import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/setting/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfRetryInterval extends GetView<SettingController> {
  const ConfRetryInterval({super.key});

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
                    FamdLocale.retryInterval.tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Obx(
                    () => TextInfo(
                        text: controller.settingConf.value.retryInterval.value +
                            FamdLocale.retryIntervalTip.tr),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => {controller.changeRetryInterval(-5)},
                ),
                Container(
                  width: 25,
                  alignment: Alignment.center,
                  child: Obx(
                    () =>
                        Text(controller.settingConf.value.retryInterval.value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => {controller.changeRetryInterval(5)},
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
