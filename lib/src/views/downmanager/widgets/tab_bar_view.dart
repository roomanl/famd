import 'package:famd/src/views/downmanager/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'task_list.dart';
import 'task_list_finish.dart';

class TabBarViewWidget extends GetView<DownManagerController> {
  const TabBarViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller.tabController,
      children: const <Widget>[
        Center(
          child: TaskListWidget(),
        ),
        Center(
          child: TaskListFinishWidget(),
        ),
      ],
    );
  }
}
