import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:famd/src/controller/app.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/utils/aria2/aria2_manager.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  final _appCtrl = Get.find<AppController>();
  StreamSubscription? _subscription;
  RxString startBtnText = FamdLocale.ariaStarting.tr.obs;
  bool _isStartServer = false;
  int _count = 0;

  @override
  void onReady() {
    super.onReady();
    _init();
  }

  @override
  void onClose() {
    if (_subscription != null) {
      _subscription?.cancel();
    }
    super.onClose();
  }

  _init() async {
    Aria2Manager().closeServer();
    if (!await _checkNetwork()) {
      return;
    }
    _aria2OnlineListener();
    await Aria2Manager().initAria2Conf();
    startAria2();
  }

  startAria2() async {
    if (!await _checkNetwork()) {
      return;
    }
    if (_isStartServer) {
      return;
    }
    if (!Aria2Manager().online) {
      _updateStartBtnText(FamdLocale.ariaStarting.tr);
      _isStartServer = true;
      Aria2Manager().startServer();
    }
  }

  _aria2OnlineListener() {
    _subscription = _appCtrl.aria2Online.listen((val) {
      // print(val);
      _openHomePage(val);
    });
  }

  _openHomePage(online) {
    if (_isStartServer) {
      _count++;
    }
    if (online) {
      // Get.toNamed('/home');
      Get.offNamed('/home');
      if (_subscription != null) {
        _subscription?.cancel();
      }
    } else if (_isStartServer && _count > 30) {
      ///监听aria2服务状态，30S内没监听到aria2服务在线判定为启动失败
      _updateStartBtnText(FamdLocale.ariaStartFail.tr);
      _isStartServer = false;
      _count = 0;
    }
  }

  _checkNetwork() async {
    try {
      final Connectivity connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      if (result.length == 1 && result.contains(ConnectivityResult.none)) {
        _updateStartBtnText(FamdLocale.notNet.tr);
        return false;
      }
      return true;
    } catch (e) {
      _updateStartBtnText(FamdLocale.errorNet.tr);
      return false;
    }
  }

  _updateStartBtnText(text) {
    startBtnText.update((val) {
      startBtnText.value = text;
    });
  }
}
