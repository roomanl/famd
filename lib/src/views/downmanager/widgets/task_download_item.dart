import 'package:famd/src/components/text/text_danger.dart';
import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/components/text/text_primary.dart';
import 'package:famd/src/components/text/text_success.dart';
import 'package:famd/src/controller/task.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskDownloadItem extends GetView<TaskController> {
  final M3u8Task task;
  const TaskDownloadItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
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
                  Obx(
                    () => TextPrimary(text: '${controller.downStatusInfo}'),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Divider(thickness: 1, height: 0.5),
          ),
          Obx(
            () => Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextInfo(
                        text: '速      度：${controller.taskInfo.value.speed}/S',
                        opacity: 0.4,
                      ),
                      TextInfo(
                        text: '分 片  数：${controller.taskInfo.value.tsTotal}',
                        opacity: 0.4,
                      ),
                      TextInfo(
                        text: '解密状态：${controller.taskInfo.value.tsDecrty}',
                        opacity: 0.4,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextInfo(
                        text: '下 载 进 度：${controller.taskInfo.value.progress}',
                        opacity: 0.4,
                      ),
                      Row(
                        children: <Widget>[
                          const TextInfo(
                            text: '分片下载数：',
                            opacity: 0.4,
                          ),
                          TextSuccess(
                            text: '${controller.taskInfo.value.tsSuccess}',
                          ),
                          const TextInfo(
                            text: ' / ',
                            opacity: 0.4,
                          ),
                          TextDanger(
                            text: '${controller.taskInfo.value.tsFail}',
                          ),
                        ],
                      ),
                      TextInfo(
                        text:
                            '合 并 状 态：${controller.taskInfo.value.mergeStatus}',
                        opacity: 0.4,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
