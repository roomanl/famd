import 'package:famd/src/common/color.dart';
import 'package:famd/src/components/text/text_danger.dart';
import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/components/text/text_success.dart';
import 'package:famd/src/controller/task.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:famd/src/views/downmanager/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskListFinishWidget extends GetView<DownManagerController> {
  const TaskListFinishWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (taskController) {
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: taskController.finishTaskList.length,
          itemBuilder: (BuildContext context, int index) {
            M3u8Task task = taskController.finishTaskList[index];
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextInfo(
                          text: taskFullName(task),
                          fontSize: 16.0,
                        ),
                      ),
                      _buildStatusIcon(task),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: FamdColor.colorSCH,
                        ),
                        onPressed: () {
                          controller.deleteTask(task, true);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      _buildTextInfo(task),
                      const TextInfo(
                        text: '  |  ',
                        opacity: 0.4,
                      ),
                      TextInfo(
                        text: task.createtime ?? '0000-00-00 00:00:00',
                        opacity: 0.4,
                      ),
                      const TextInfo(
                        text: '  |  ',
                        opacity: 0.4,
                      ),
                      TextInfo(
                        text: task.filesize ?? '0M',
                        opacity: 0.4,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(thickness: 1, height: 1),
        );
      },
    );
  }

  _buildStatusIcon(M3u8Task task) {
    return task.status == 3
        ? IconButton(
            icon: const Icon(
              Icons.play_circle_outline,
              color: FamdColor.colorFLV,
            ),
            onPressed: () {
              controller.playerVideo(task);
            },
          )
        : IconButton(
            icon: const Icon(
              Icons.restart_alt_outlined,
              color: FamdColor.colorSCH,
            ),
            onPressed: () async {
              controller.resetFailTask(task.id!);
            },
          );
  }

  _buildTextInfo(M3u8Task task) {
    return task.status == 3
        ? TextSuccess(text: FamdLocale.downSuccess.tr)
        : TextDanger(text: task.remarks ?? FamdLocale.downFail.tr);
  }
}
