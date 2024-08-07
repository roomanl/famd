import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:famd/src/controller/app.dart';
import 'package:famd/src/utils/aria2/aria2_manager.dart';
import 'package:famd/src/views/home/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  final _appCtrl = Get.find<AppController>();
  StreamSubscription? _subscription;
  RxString startBtnText = 'Aria2启动中...'.obs;
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
      print('取消订阅');
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
      _updateStartBtnText('Aria2启动中...');
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
      Get.toNamed('/home');
      // Get.offNamed('/home');
      // Navigator.of(Get.context!).pop();
      // Navigator.of(Get.context!).push(MaterialPageRoute(
      //     builder: (BuildContext context) => const HomePage()));
      if (_subscription != null) {
        _subscription?.cancel();
        print('取消订阅');
      }
    } else if (_isStartServer && _count > 30) {
      ///监听aria2服务状态，30S内没监听到aria2服务在线判定为启动失败
      _updateStartBtnText('启动失败!');
      _isStartServer = false;
      _count = 0;
    }
  }

  _checkNetwork() async {
    try {
      final Connectivity connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      if (result.length == 1 && result.contains(ConnectivityResult.none)) {
        _updateStartBtnText('未连接网络');
        return false;
      }
      return true;
    } catch (e) {
      _updateStartBtnText('网络连接异常');
      return false;
    }
  }

  _updateStartBtnText(text) {
    startBtnText.update((val) {
      startBtnText.value = text;
    });
  }
}
