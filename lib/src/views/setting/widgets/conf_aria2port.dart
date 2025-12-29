import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/setting/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfAria2Port extends GetView<SettingController> {
  const ConfAria2Port({super.key});

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
                    FamdLocale.aria2Port.tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                  TextInfo(text: FamdLocale.restartToTakeEffect.tr),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 40,
              alignment: Alignment.center,
              child: TextField(
                controller: controller.aria2PortTextController,
                autofocus: false,
                expands: true,
                maxLines: null, // 必须设置为null
                minLines: null, // 必须设置为null
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0, // 垂直方向内边距
                    horizontal: 10.0, // 水平方向内边距
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
