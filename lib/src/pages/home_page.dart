import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:window_manager/window_manager.dart';
import '../common/const.dart';
import '../components/page_view.dart' as MyPageView;
import '../states/app_states.dart';
import '../utils/aria2_manager.dart';
import 'add_task_page.dart';
import 'appinfo_page.dart';
import 'down_manager.dart';
import 'setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            _buildLeftNavigation(),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              /// 自带PageView只能缓存1个页面，因为与IOS辅助功能有冲突，
              /// 这里复制ageView源码，增加自定义缓存参数cacheExtentNum
              child: MyPageView.PageView(
                controller: _pageController,
                allowImplicitScrolling: true,
                cacheExtentNum: 4.0,
                children: const [
                  AddTaskPage(),
                  DownManagerPage(),
                  SettingPage(),
                  AppinfoPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<NavigationRailDestination> destinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.add),
      label: Text('添加任务'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.list),
      label: Text('任务管理'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings),
      label: Text('设置'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.info),
      label: Text('关于'),
    ),
  ];
  final MyPageView.PageController _pageController =
      MyPageView.PageController(initialPage: 1);
  final _appCtrl = Get.put(AppController());
  late bool isStartServer = false;
  late int startCount = 0;
  static const Color textColor = Color(0xffcfd1d7);
  static const Color activeColor = Color.fromRGBO(27, 167, 132, 1);
  static const TextStyle labelStyle =
      TextStyle(color: textColor, fontSize: 11, fontFamily: 'FangYuan2');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isWindows || Platform.isLinux) {
      windowManager.addListener(this);
    }
    taskStatesListener();
  }

  @override
  void dispose() {
    if (Platform.isWindows || Platform.isLinux) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void onWindowClose() {
    ///关闭软件时关闭aria2服务
    Aria2Manager().closeServer();
  }

  taskStatesListener() {
    ///监听页码变化跳转页面
    _appCtrl.pageIndex.listen((val) {
      if (_pageController.page != val) {
        _pageController.jumpToPage(_appCtrl.pageIndex.value);
      }
    });

    ///监听aria2服务状态
    _appCtrl.aria2Online.listen((val) {
      listenerAria2Status(val);
    });
  }

  listenerAria2Status(online) {
    if (isStartServer && startCount > 10) {
      EasyLoading.showError("启动失败");
    } else if (isStartServer && online) {
      isStartServer = false;
      EasyLoading.showSuccess("启动成功");
    }
  }

  startAria2() {
    if (isStartServer) {
      return;
    }
    if (_appCtrl.aria2Online.isFalse) {
      EasyLoading.show(status: '启动中...');
      isStartServer = true;
      Aria2Manager().startServer();
    }
  }

  Widget _buildLeftNavigation() {
    return Obx(() => NavigationRail(
          labelType: NavigationRailLabelType.none,
          backgroundColor: mainColor,
          unselectedIconTheme: const IconThemeData(color: textColor),
          selectedIconTheme: const IconThemeData(color: activeColor),
          unselectedLabelTextStyle: labelStyle,
          selectedLabelTextStyle: labelStyle,
          onDestinationSelected: _onDestinationSelected,
          destinations: destinations,
          selectedIndex: _appCtrl.pageIndex.value,
          // leading: IconButton(
          //   icon: Image.asset('lib/resources/images/logo.png',
          //       width: 40, height: 40),
          //   onPressed: () {},
          // ),
          trailing: Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: IconButton(
                  icon: _appCtrl.aria2Online.isTrue
                      ? Image.asset('lib/resources/images/online.png',
                          width: 40, height: 40)
                      : Image.asset('lib/resources/images/offline.png',
                          width: 40, height: 40),
                  onPressed: () {
                    startAria2();
                  },
                ),
              ),
            ),
          ),
        ));
  }

  void _onDestinationSelected(int index) {
    ///添加任务后需自动跳转到任务管理页，需要在别的页面更改页码，因此把页码交给状态管理
    _appCtrl.updatePageIndex(index);
    // _pageController.jumpToPage(index);
  }
}
