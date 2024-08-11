import 'package:famd/src/common/color.dart';
import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/components/text/text_warning.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:famd/src/views/downmanager/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskWaitItem extends GetView<DownManagerController> {
  final M3u8Task task;
  const TaskWaitItem({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
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
              const Icon(
                Icons.query_builder_rounded,
                color: FamdColor.colorKQL,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: FamdColor.colorSCH,
                ),
                onPressed: () => {controller.deleteTask(task, false)},
              ),
            ],
          ),
          Row(
            children: <Widget>[
              TextWarning(
                text: FamdLocale.waitDown.tr,
              ),
              const TextInfo(
                text: '  |  ',
                opacity: 0.4,
              ),
              TextInfo(
                text: task.createtime ?? '0000-00-00 00:00:00',
                opacity: 0.4,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
