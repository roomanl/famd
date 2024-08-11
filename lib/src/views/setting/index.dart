import 'package:famd/src/locale/locale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/widgets.dart';
import 'controller.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(FamdLocale.setting.tr),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const <Widget>[
          ConfDownFolderWidget(),
          Divider(thickness: 1, height: 1),
          SizedBox(height: 10),
          ConfThemeColorWidget(),
          Divider(thickness: 1, height: 1),
          SizedBox(height: 10),
          ConfDarkMode(),
          Divider(thickness: 1, height: 1),
        ],
      ),
    );
  }
}
