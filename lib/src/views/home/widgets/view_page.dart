import 'package:famd/src/components/bar/title_bar.dart';
import 'package:famd/src/views/about/index.dart';
import 'package:famd/src/views/addtask/index.dart';
import 'package:famd/src/views/downmanager/index.dart';
import 'package:famd/src/views/home/controller.dart';
import 'package:famd/src/components/page_view.dart' as HomePageView;
import 'package:famd/src/views/m3u8web/index.dart';
import 'package:famd/src/views/setting/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewPageWidget extends GetView<HomeController> {
  const HomeViewPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /// 自带PageView只能缓存1个页面，因为与IOS辅助功能有冲突，
    /// 这里复制ageView源码，增加自定义缓存参数cacheExtentNum
    return WinTitleBar(
      useThemeColor: false,
      autoHide: true,
      child: HomePageView.PageView(
        controller: controller.pageController,
        allowImplicitScrolling: true,
        physics: const NeverScrollableScrollPhysics(),
        cacheExtentNum: 4,
        children: const [
          AddTaskPage(),
          DownManagerPage(),
          M3U8WebPage(),
          SettingPage(),
          // AboutPage(),
        ],
      ),
    );
  }
}
