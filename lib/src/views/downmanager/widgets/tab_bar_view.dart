import 'package:famd/src/views/downmanager/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'task_list.dart';

class TabBarViewWidget extends GetView<DownManagerController> {
  const TabBarViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller.tabController,
      children: const <Widget>[
        Center(
          child: TaskListWidget(),
        ),
      ],
    );
  }
}
