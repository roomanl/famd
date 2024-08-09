import 'package:famd/src/controller/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'widgets/widgets.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: controller.scaffoldKey,
        appBar: _buildAppBar(),
        body: SafeArea(
          bottom: false,
          top: false,
          child: Row(
            children: _buildcontentPage(),
          ),
        ),
        endDrawer: const HomeEndDrawerWidget(),
      ),
    );
  }

  _buildAppBar() {
    return Get.find<AppController>().showNavigationDrawer.isTrue
        ? buildTopBar()
        : null;
  }

  List<Widget> _buildcontentPage() {
    return Get.find<AppController>().showNavigationDrawer.isTrue
        ? [
            const Expanded(
              child: HomeViewPageWidget(),
            )
          ]
        : [
            const HomeLeftBarWidget(),
            const VerticalDivider(thickness: 1, width: 1),
            const Expanded(
              child: HomeViewPageWidget(),
            ),
          ];
  }
}
