import 'dart:async';
import 'package:famd/src/bindings/app.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/router/index.dart';
import 'package:famd/src/utils/db/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:window_manager/window_manager.dart';
import 'src/utils/common_utils.dart';

void main() async {
  final themeCtrl = Get.put(ThemeController());
  await DBHelper.getInstance().database;
  await themeCtrl.init();
  if (GetPlatform.isWindows || GetPlatform.isLinux) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: const Size(800, 600),
      minimumSize: const Size(400, 600),
      center: true,
      backgroundColor: themeCtrl.mainColor.value,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } else if (GetPlatform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: themeCtrl.mainColor.value,
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  FlutterError.onError = (FlutterErrorDetails details) {
    writeCrashLog(details.toString());
  };
  runZonedGuarded(() {
    runApp(GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: themeCtrl.mainFont.value,
        colorSchemeSeed: themeCtrl.mainColor.value,
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
