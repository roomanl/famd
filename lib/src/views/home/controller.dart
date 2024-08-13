import 'package:famd/src/controller/app.dart';
import 'package:famd/src/controller/input_focus.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/utils/app_update.dart';
import 'package:famd/src/utils/aria2/aria2_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:famd/src/components/page_view.dart' as HomePageView;
import 'package:window_manager/window_manager.dart';
import 'model.dart';

class HomeController extends GetxController
    with WidgetsBindingObserver, WindowListener {
  final _appCtrl = Get.find<AppController>();
  final _focusCtrl = Get.find<InputFocusController>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final HomePageView.PageController pageController =
      HomePageView.PageController(initialPage: 1);

  final leftBarStyle = LeftBarStyle();

  RxInt viewPageIndex = 1.obs;
  bool _isAria2StartServer = false;
  int _startCount = 0;

  List<NavDestination> destinations = <NavDestination>[
    NavDestination(
        FamdLocale.addTask.tr, const Icon(Icons.add_circle_outline_rounded)),
    NavDestination(FamdLocale.taskManager.tr, const Icon(Icons.home_rounded)),
    NavDestination(FamdLocale.setting.tr, const Icon(Icons.settings)),
    NavDestination(FamdLocale.about.tr, const Icon(Icons.info)),
    NavDestination(FamdLocale.find.tr, const Icon(Icons.explore_rounded))
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
    ///PageView子页面添加任务页面输入框弹起软键盘，如果不是手动关闭键盘，而是切换到其他页面关闭了键盘，
    ///这时候点击任何按钮都会回到刚刚的页面自动获取焦点，弹出软键盘
    ///获取焦点后会自动跳转到添加任务页面，导致无法切换到其他页面
    ///所在这里切换页面时去除所有输入框焦点，收起软键盘
    _focusCtrl.cleanAddTaskInputFocus();

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
      EasyLoading.show(status: FamdLocale.ariaStarting.tr);
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
        EasyLoading.showError(FamdLocale.ariaStartFail.tr);
      } else if (_isAria2StartServer && online) {
        _isAria2StartServer = false;
        EasyLoading.showSuccess(FamdLocale.ariaStartSuccess.tr);
      }
    });
  }

  openM3u8ResourcePage() {
    _focusCtrl.cleanAddTaskInputFocus();
    Get.toNamed('/search/vod');
  }

  openEndDrawer() {
    _focusCtrl.cleanAddTaskInputFocus();
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
