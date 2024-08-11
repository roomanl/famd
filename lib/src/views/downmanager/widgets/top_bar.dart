import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/downmanager/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final downCtrl = Get.find<DownManagerController>();

buildTopBarActions() {
  return <Widget>[
    SizedBox(
      width: 60,
      child: IconButton(
        icon: const Icon(Icons.play_arrow),
        tooltip: FamdLocale.startDown.tr,
        onPressed: downCtrl.startTask,
      ),
    ),
    SizedBox(
      width: 60,
      child: IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: FamdLocale.reStartDown.tr,
        onPressed: downCtrl.resetTask,
      ),
    ),
    SizedBox(
      width: 60,
      child: IconButton(
        icon: const Icon(Icons.delete_forever),
        tooltip: FamdLocale.cleanTask.tr,
        onPressed: downCtrl.deleteAllTask,
      ),
    ),
  ];
}

buildTopBarBottom() {
  return TabBar(
    controller: downCtrl.tabController,
    tabs: <Widget>[
      Tab(text: FamdLocale.downloading.tr),
      Tab(text: FamdLocale.downFinish.tr),
    ],
  );
}
