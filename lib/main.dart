import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import './src/pages/start_page.dart';
import 'src/common/color.dart';
import 'src/states/app_states.dart';
import 'src/utils/common_utils.dart';
import 'src/utils/setting_conf_utils.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      minimumSize: Size(400, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } else if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  final _themeCtrl = Get.put(CustomThemeController());
  CustomThemeColor themeColor = await getThemeColor();
  _themeCtrl.updateMainColor(themeColor.color);
  FlutterError.onError = (FlutterErrorDetails details) {
    writeCrashLog(details.toString());
  };
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
