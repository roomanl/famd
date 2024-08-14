import 'dart:async';
import 'package:famd/src/bindings/app.dart';
import 'package:famd/src/common/color.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/locale/messages.dart';
import 'package:famd/src/router/index.dart';
import 'package:famd/src/utils/db/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:window_manager/window_manager.dart';
import 'src/utils/common_utils.dart';

void main() async {
  // final themeCtrl = Get.put(ThemeController());
  // await DBHelper.getInstance().database;
  // await themeCtrl.init();
  if (GetPlatform.isWindows || GetPlatform.isLinux) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      minimumSize: Size(400, 600),
      center: true,
      backgroundColor: FamdColor.colorJFZ,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } else if (GetPlatform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  FlutterError.onError = (FlutterErrorDetails details) {
    writeCrashLog(details.toString());
  };
  runZonedGuarded(() {
    runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'FangYuan2',
        colorSchemeSeed: FamdColor.colorJFZ,
      ),
      // home: const StartPage(),
      initialRoute: '/',
      initialBinding: AppBinding(),
      getPages: RoutePages.list,
      translations: Messages(),
      locale: const Locale('zh', 'CN'),
      builder: EasyLoading.init(),
    ));
  }, (Object obj, StackTrace stack) {
    writeCrashLog(obj.toString());
  });
}
