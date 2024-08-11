import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/setting/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ConfDarkMode extends GetView<SettingController> {
  const ConfDarkMode({super.key});

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
                    FamdLocale.darkMode.tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Obx(
                    () => TextInfo(
                      text: controller.isDarkMode.value
                          ? FamdLocale.on.tr
                          : FamdLocale.off.tr,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => CupertinoSwitch(
                value: controller.isDarkMode.value,
                activeColor: CupertinoColors.activeGreen,
                onChanged: (bool? value) {
                  controller.changeDarkMode(value ?? false);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
