import 'package:famd/src/common/color.dart';
import 'package:famd/src/views/setting/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfThemeColorWidget extends GetView<SettingController> {
  const ConfThemeColorWidget({Key? key}) : super(key: key);

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
                  const Text(
                    '主题色',
                    style: TextStyle(fontSize: 18),
                  ),
                  Obx(
                    () => Text(
                      controller.settingConf.value.themeColor.value,
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromARGB(100, 0, 0, 0)),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                selectThemeColor();
              },
              child: const Text('更改'),
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
            title: const Text("选择主题色"),
            children: [
              ...themeColors.map((CustomThemeColor themeColor) {
                return SimpleDialogOption(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Text(themeColor.label),
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
