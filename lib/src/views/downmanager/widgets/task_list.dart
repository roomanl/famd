import 'package:famd/src/controller/task.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/views/downmanager/widgets/task_download_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'task_wait_item.dart';

class TaskListWidget extends GetView<TaskController> {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (_) {
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: controller.taskList.length,
          itemBuilder: (BuildContext context, int index) {
            M3u8Task task = controller.taskList[index];
            // task.status = 2;
            if (task.status == 1) {
              return TaskWaitItem(task: task);
            } else if (task.status == 2) {
              return TaskDownloadItem(task: task);
            }
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(thickness: 1, height: 1),
        );
      },
    );
  }
}
