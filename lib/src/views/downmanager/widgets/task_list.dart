import 'package:famd/src/controller/task.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/views/downmanager/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'item_download.dart';

class TaskListWidget extends GetView<TaskController> {
  const TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: controller.taskLength.value,
        itemBuilder: (BuildContext context, int index) {
          M3u8Task task = controller.taskList[index];
          if (task.status == 1) {
            return Text("data");
            // return buildItemDownload(task);
          } else if (task.status == 2) {
            return Text("data");
          }
        },
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(thickness: 1, height: 1),
      ),
    );
  }
}
