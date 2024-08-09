import 'package:famd/src/common/color.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/utils/db/DBHelper.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:famd/src/utils/common_utils.dart';
import 'package:window_manager/window_manager.dart';

class AppController extends GetxController with WidgetsBindingObserver {
  final _themeCtrl = Get.find<ThemeController>();
  RxString appVersion = '1.0'.obs;
  RxBool aria2Online = false.obs;
  RxInt aria2Speed = 0.obs;
  RxBool showNavigationDrawer = false.obs;

  @override
  void onReady() {
    super.onReady();
    print("AppController onReady");
    _init();
    changWinSize();
    updateAppVersion();
  }

  _init() async {
    DBHelper.getInstance().database;
    CustomThemeColor themeColor = await getThemeColor();
    _themeCtrl.updateMainColor(themeColor.color);
    if (GetPlatform.isWindows || GetPlatform.isLinux) {
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
    } else if (GetPlatform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: themeColor.color,
          statusBarIconBrightness: Brightness.dark);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    FlutterError.onError = (FlutterErrorDetails details) {
      writeCrashLog(details.toString());
    };
  }

  updateAppVersion() {
    appVersion.update((val) async {
      appVersion.value = await getAppVersion();
    });
  }

  updateAria2Online(bool online) {
    aria2Online.update((val) {
      aria2Online.value = online;
    });
  }

  updateAria2Speed(int speed) {
    aria2Speed.update((val) {
      aria2Speed.value = speed;
    });
  }

  updateShowNavigationDrawer(bool online) {
    showNavigationDrawer.update((val) {
      showNavigationDrawer.value = online;
    });
  }

  changWinSize() {
    updateShowNavigationDrawer(MediaQuery.of(Get.context!).size.width <= 500);
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    changWinSize();
    // print("didChangeMetrics");
  }
}
