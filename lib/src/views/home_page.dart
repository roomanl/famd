import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import '../components/page_view.dart' as MyPageView;
import '../view_models/app_states.dart';
import '../utils/app_update.dart';
import '../utils/aria2/aria2_manager.dart';
import 'add_task_page.dart';
import 'appinfo_page.dart';
import 'down_manager.dart';
import 'setting_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  @override
  Widget build(BuildContext context) {
    return _buildNavigation();
  }

  Widget _buildNavigation() {
    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBar(),
      body: SafeArea(
        bottom: false,
        top: false,
        child: Row(
          children: _buildcontentPage(),
        ),
      ),
      endDrawer: NavigationDrawer(
        onDestinationSelected: _handleScreenChanged,
        selectedIndex: -1,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('lib/resources/images/logo.png',
                      width: 40, height: 40),
                ),
                Text(
                  'Famd M3U8下载器',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          ...destinations.map(
            (NavDestination destination) {
              return NavigationDrawerDestination(
                label: Text(destination.label),
                icon: destination.icon,
              );
            },
          ),
          const NavigationDrawerDestination(
            label: Text('检查更新'),
            icon: Icon(Icons.update_rounded),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),
        ],
      ),
    );
  }

  AppBar? _buildAppBar() {
    return _appCtrl.showNavigationDrawer.isTrue
        ? AppBar(
            backgroundColor: _themeCtrl.mainColor.value,
            title: const Text(
              'Famd',
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
            leading: IconButton(
              color: const Color.fromRGBO(255, 255, 255, 1),
              icon: const Icon(Icons.home_rounded),
              onPressed: () => {_changePageView(1)},
            ),
            actions: <Widget>[
              SizedBox(
                width: 50,
                child: Obx(() => _buildWifiIcon()),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  onPressed: () {
                    _changePageView(0);
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  icon: const Icon(Icons.explore_rounded),
                  onPressed: () {
                    _openM3u8ResourcePage();
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: () {
                    scaffoldKey.currentState!.openEndDrawer();
                  },
                ),
              ),
            ],
          )
        : null;
  }

  List<Widget> _buildcontentPage() {
    return _appCtrl.showNavigationDrawer.isTrue
        ? [
            Expanded(
              child: _buildViewPage(),
            )
          ]
        : [
            Obx(() => NavigationRail(
                  labelType: NavigationRailLabelType.none,
                  backgroundColor: _themeCtrl.mainColor.value,
                  unselectedIconTheme: const IconThemeData(color: textColor),
                  selectedIconTheme: const IconThemeData(color: activeColor),
                  unselectedLabelTextStyle: labelStyle,
                  selectedLabelTextStyle: labelStyle,
                  onDestinationSelected: _handleScreenChanged,
                  destinations: destinations.map(
                    (NavDestination destination) {
                      return NavigationRailDestination(
                        label: Text(destination.label),
                        icon: destination.icon,
                      );
                    },
                  ).toList(),
                  selectedIndex: _appCtrl.pageIndex.value,
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: _buildWifiIcon(),
                      ),
                    ),
                  ),
                )),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              /// 自带PageView只能缓存1个页面，因为与IOS辅助功能有冲突，
              /// 这里复制ageView源码，增加自定义缓存参数cacheExtentNum
              child: _buildViewPage(),
            ),
          ];
  }

  Widget _buildViewPage() {
    /// 自带PageView只能缓存1个页面，因为与IOS辅助功能有冲突，
    /// 这里复制ageView源码，增加自定义缓存参数cacheExtentNum
    return MyPageView.PageView(
      controller: _pageController,
      allowImplicitScrolling: true,
      // physics: const NeverScrollableScrollPhysics(),
      cacheExtentNum: 4,
      children: const [
        AddTaskPage(),
        DownManagerPage(),
        SettingPage(),
        AppinfoPage(),
      ],
    );
  }

  Widget _buildWifiIcon() {
    Widget icon = _appCtrl.aria2Online.isTrue
        ? Image.asset('lib/resources/images/online.png', width: 25, height: 25)
        : Image.asset('lib/resources/images/offline.png',
            width: 25, height: 25);
    return IconButton(
      icon: icon,
      onPressed: () {
        startAria2();
      },
    );
  }

  List<NavDestination> destinations = const <NavDestination>[
    NavDestination('添加任务', Icon(Icons.add_circle_outline_rounded)),
    NavDestination('任务管理', Icon(Icons.home_rounded)),
    NavDestination('设置', Icon(Icons.settings)),
    NavDestination('关于', Icon(Icons.info)),
    NavDestination('探索', Icon(Icons.explore_rounded))
  ];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final MyPageView.PageController _pageController =
      MyPageView.PageController(initialPage: 1);
  final _appCtrl = Get.put(AppController());
  final _themeCtrl = Get.put(CustomThemeController());
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
    checkAppUpdate(context, false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final showDrawer = MediaQuery.of(context).size.width <= 500;

    ///如果应用宽度>500时，EndDrawer还是弹出状态的话，就关闭它
    ///这里有问题展示注释
    // if (!showDrawer && scaffoldKey.currentState!.isEndDrawerOpen) {
    //   scaffoldKey.currentState!.closeEndDrawer();
    // }
    _appCtrl.updateShowNavigationDrawer(showDrawer);
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
      if (_pageController.hasClients && _pageController.page != val) {
        _pageController.jumpToPage(val);
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

  void _changePageView(int index) {
    ///不知道为什么在android切换页面的时候，添加任务页面中的输入框老是会自动获取焦点
    ///获取焦点后会自动跳转到添加任务页面，导致无法切换到其他页面
    ///所在这里切换页面时去除所有输入框焦点
    FocusScope.of(context).requestFocus(FocusNode());

    ///添加任务后需自动跳转到任务管理页，需要在别的页面更改页码，因此把页码交给状态管理
    _appCtrl.updatePageIndex(index);
    // _pageController.jumpToPage(index);
  }

  void _handleScreenChanged(int selectedScreen) {
    if (selectedScreen == 4) {
      _openM3u8ResourcePage();
    } else if (selectedScreen == 5) {
      checkAppUpdate(context, true);
    } else {
      _changePageView(selectedScreen);
      scaffoldKey.currentState!.closeEndDrawer();
    }
  }

  void _openM3u8ResourcePage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const SearchPage()));
  }
}

class NavDestination {
  const NavDestination(this.label, this.icon);

  final String label;
  final Widget icon;
}
