import 'package:famd/src/locale/locale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'widgets/widgets.dart';

class DownManagerPage extends GetView<DownManagerController> {
  const DownManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(FamdLocale.taskManager.tr),
        actions: buildTopBarActions(),
        bottom: buildTopBarBottom(),
      ),
      body: const TabBarViewWidget(),
    );
  }
}
