import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/welcome/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTileWidget extends GetView<WelcomeController> {
  const AppTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          FamdLocale.appName.tr,
          style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              fontWeight: FontWeight.bold,
              fontSize: 36),
        ),
        Text(
          FamdLocale.channelName.tr,
          style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              fontWeight: FontWeight.bold,
              fontSize: 36),
        ),
      ],
    );
  }
}
