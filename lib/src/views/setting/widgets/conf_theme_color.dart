import 'package:famd/src/common/color.dart';
import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/setting/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfThemeColorWidget extends GetView<SettingController> {
  const ConfThemeColorWidget({super.key});

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
                    FamdLocale.themeColor.tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Obx(
                    () => TextInfo(
                      text: controller.settingConf.value.themeColor.value.tr,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                selectThemeColor();
              },
              child: Text(FamdLocale.change.tr),
            ),
          ],
        );
      },
    );
  }

  selectThemeColor() {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: Text(FamdLocale.selectThemeColor.tr),
            children: [
              ...FamdColor.themeColors.map((FamdThemeColor themeColor) {
                return SimpleDialogOption(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Text(themeColor.label.tr),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        color: themeColor.color,
                      ),
                    ],
                  ),
                  onPressed: () {
                    controller.changeThemeColor(themeColor);
                    Navigator.of(context).pop();
                  },
                );
              }),
            ],
          );
        });
  }
}
