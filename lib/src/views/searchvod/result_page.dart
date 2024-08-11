import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'result_controller.dart';

class ResultVodPage extends GetView<ResultVodController> {
  const ResultVodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    return GetBuilder<ResultVodController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: themeCtrl.mainColor.value,
            leadingWidth: 40,
            leading: IconButton(
              color: const Color.fromRGBO(255, 255, 255, 1),
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              controller.vodName.value,
              style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            ),
            bottom: TabBar(
              controller: controller.tabController,
              tabs: _buildTabsTitle(),
            ),
          ),
          body: TabBarView(
            controller: controller.tabController,
            children: _buildTabView(),
          ),
        );
      },
    );
  }

  List<Widget> _buildTabsTitle() {
    List<Widget> tabs = [];
    for (int i = 0; controller.m3u8Res.length > i; i++) {
      tabs.add(Tab(text: '${FamdLocale.source.tr}${i + 1}'));
    }
    return tabs;
  }

  List<Widget> _buildTabView() {
    List<Widget> tabView = [];
    for (int i = 0; controller.m3u8Res.length > i; i++) {
      var episodes = controller.m3u8Res[i];
      List<Widget> gridTiles = [];
      for (int j = 0; episodes.length > j; j++) {
        gridTiles.add(
          OutlinedButton(
            onPressed: () {
              controller.addTask(episodes[j]);
            },
            child: Text(episodes[j]['label']),
          ),
        );
      }
      var grid = SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          spacing: 8.0, // 水平间距
          runSpacing: 8.0,
          children: gridTiles,
        ),
      );

      tabView.add(grid);
    }
    return tabView;
  }
}
