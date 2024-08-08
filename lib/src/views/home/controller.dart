import 'package:famd/src/controller/app.dart';
import 'package:famd/src/utils/app_update.dart';
import 'package:famd/src/utils/aria2/aria2_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:famd/src/components/page_view.dart' as HomePageView;
import 'package:logger/logger.dart';
import 'package:window_manager/window_manager.dart';
import 'model.dart';

class HomeController extends GetxController
    with WidgetsBindingObserver, WindowListener {
  final _appCtrl = Get.find<AppController>();
  final Logger _logger = Logger();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final HomePageView.PageController pageController =
      HomePageView.PageController(initialPage: 1);

  final leftBarStyle = LeftBarStyle();

  RxInt viewPageIndex = 1.obs;
  bool _isAria2StartServer = false;
  int _startCount = 0;

  List<NavDestination> destinations = const <NavDestination>[
    NavDestination('添加任务', Icon(Icons.add_circle_outline_rounded)),
    NavDestination('任务管理', Icon(Icons.home_rounded)),
    NavDestination('设置', Icon(Icons.settings)),
    NavDestination('关于', Icon(Icons.info)),
    NavDestination('探索', Icon(Icons.explore_rounded))
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    if (GetPlatform.isWindows || GetPlatform.isLinux) {
      windowManager.addListener(this);
    }
  }

  @override
  void onReady() {
    super.onReady();
    _init();
    // Get.removeRoute();
    // _logger.i();
  }

  _init() async {
    _aria2OnlineListener();
    checkAppUpdate(Get.context!, false);
    _appCtrl.changWinSize();
  }

  changePageView(int index) {
    ///不知道为什么在android切换页面的时候，添加任务页面中的输入框老是会自动获取焦点
    ///获取焦点后会自动跳转到添加任务页面，导致无法切换到其他页面
    ///所在这里切换页面时去除所有输入框焦点
    FocusScope.of(Get.context!).requestFocus(FocusNode());

    ///添加任务后需自动跳转到任务管理页，需要在别的页面更改页码，因此把页码交给状态管理
    updateViewPageIndex(index);
    pageController.jumpToPage(index);
  }

  updateViewPageIndex(int index) {
    viewPageIndex.update((val) {
      viewPageIndex.value = index;
      // updateAria2Online(true);
    });
  }

  handleScreenChanged(int selectedScreen) {
    if (selectedScreen == 4) {
      openM3u8ResourcePage();
    } else if (selectedScreen == 5) {
      checkAppUpdate(Get.context!, true);
    } else {
      changePageView(selectedScreen);
      closeEndDrawer();
    }
  }

  closAria2() {
    Aria2Manager().closeServer();
  }

  startAria2() {
    if (_isAria2StartServer) {
      return;
    }
    if (_appCtrl.aria2Online.isFalse) {
      EasyLoading.show(status: '启动中...');
      _isAria2StartServer = true;
      _startCount = 0;
      Aria2Manager().startServer();
    }
  }

  _aria2OnlineListener() {
    _appCtrl.aria2Online.listen((online) {
      if (_isAria2StartServer) {
        _startCount++;
      }
      if (_isAria2StartServer && _startCount > 10) {
        EasyLoading.showError("启动失败");
      } else if (_isAria2StartServer && online) {
        _isAria2StartServer = false;
        EasyLoading.showSuccess("启动成功");
      }
    });
  }

  openM3u8ResourcePage() {
    Get.toNamed('/search');
  }

  openEndDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  closeEndDrawer() {
    scaffoldKey.currentState!.closeEndDrawer();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    if (GetPlatform.isWindows || GetPlatform.isLinux) {
      windowManager.removeListener(this);
    }
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _appCtrl.changWinSize();
    // print("didChangeMetrics");
  }

  @override
  void onWindowClose() {
    ///关闭软件时关闭aria2服务
    closAria2();
    if (GetPlatform.isWindows || GetPlatform.isLinux) {
      windowManager.removeListener(this);
    }
  }
}
