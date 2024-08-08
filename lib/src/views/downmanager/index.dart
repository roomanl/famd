import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'widgets/widgets.dart';

class DownManagerPage extends GetView<DownManagerController> {
  const DownManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final appCtrl = Get.find<AppController>();
    return GetBuilder<DownManagerController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('任务管理'),
            actions: buildTopBarActions(),
            bottom: buildTopBarBottom(),
          ),
          body: const TabBarViewWidget(),
        );
      },
    );
  }
}
