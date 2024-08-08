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
        tooltip: '开始下载',
        onPressed: downCtrl.startTask,
      ),
    ),
    SizedBox(
      width: 60,
      child: IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: '重新下载',
        onPressed: downCtrl.resetTask,
      ),
    ),
    SizedBox(
      width: 60,
      child: IconButton(
        icon: const Icon(Icons.delete_forever),
        tooltip: '清空任务',
        onPressed: downCtrl.deleteAllTask,
      ),
    ),
  ];
}

buildTopBarBottom() {
  return TabBar(
    controller: downCtrl.tabController,
    tabs: const <Widget>[
      Tab(text: '下载中'),
      Tab(text: '下载完成'),
    ],
  );
}
