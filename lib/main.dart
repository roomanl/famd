import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'src/views/start_page.dart';
import 'src/common/color.dart';
import 'src/view_models/app_states.dart';
import 'src/utils/common_utils.dart';
import 'src/utils/setting_conf_utils.dart';
import 'package:famd/src/utils/db/DBHelper.dart';

void main() async {
  final _themeCtrl = Get.put(CustomThemeController());
  CustomThemeColor themeColor = await getThemeColor();
  _themeCtrl.updateMainColor(themeColor.color);

  if (Platform.isWindows || Platform.isLinux) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: const Size(800, 600),
      minimumSize: const Size(400, 600),
      center: true,
      backgroundColor: themeColor.color,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } else if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: themeColor.color,
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    writeCrashLog(details.toString());
  };
  DBHelper.getInstance().database;
  runZonedGuarded(() {
    runApp(GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "FangYuan2",
        colorSchemeSeed: themeColor.color,
      ),
      home: const StartPage(),
      builder: EasyLoading.init(),
    ));
  }, (Object obj, StackTrace stack) {
    writeCrashLog(obj.toString());
  });
}
