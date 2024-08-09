import 'dart:async';
import 'package:famd/src/bindings/app.dart';
import 'package:famd/src/router/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'src/common/color.dart';
import 'src/utils/common_utils.dart';
import 'src/utils/setting_conf_utils.dart';

void main() async {
  CustomThemeColor themeColor = await getThemeColor();
  runZonedGuarded(() {
    runApp(GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "FangYuan2",
        colorSchemeSeed: themeColor.color,
      ),
      // home: const StartPage(),
      initialRoute: '/',
      initialBinding: AppBinding(),
      getPages: RoutePages.list,
      builder: EasyLoading.init(),
    ));
  }, (Object obj, StackTrace stack) {
    writeCrashLog(obj.toString());
  });
}
