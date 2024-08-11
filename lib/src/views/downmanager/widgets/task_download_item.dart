import 'package:famd/src/components/text/text_danger.dart';
import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/components/text/text_primary.dart';
import 'package:famd/src/components/text/text_success.dart';
import 'package:famd/src/controller/task.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskDownloadItem extends GetView<TaskController> {
  final M3u8Task task;
  const TaskDownloadItem({
    super.key,
    required this.task,
  });

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
                        text:
                            '${FamdLocale.downSpeed.tr}：${controller.taskInfo.value.speed}/S',
                        opacity: 0.4,
                      ),
                      TextInfo(
                        text:
                            '${FamdLocale.tsNum.tr}：${controller.taskInfo.value.tsTotal}',
                        opacity: 0.4,
                      ),
                      TextInfo(
                        text:
                            '${FamdLocale.decrtyStatus.tr}：${controller.taskInfo.value.tsDecrty}',
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
                        text:
                            '${FamdLocale.downProgress.tr}：${controller.taskInfo.value.progress}',
                        opacity: 0.4,
                      ),
                      Row(
                        children: <Widget>[
                          TextInfo(
                            text: '${FamdLocale.downTsNum.tr}：',
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
                            '${FamdLocale.mergeStatus.tr}：${controller.taskInfo.value.mergeStatus}',
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
