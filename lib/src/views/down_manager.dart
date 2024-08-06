import 'package:famd/src/common/color.dart';
import 'package:famd/src/components/dialog/confirm_dialog.dart';
import 'package:famd/src/components/text/text_danger.dart';
import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/components/text/text_primary.dart';
import 'package:famd/src/components/text/text_success.dart';
import 'package:famd/src/components/text/text_warning.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/utils/common_utils.dart';
import 'package:famd/src/utils/file/file_utils.dart';
import 'package:famd/src/utils/task/task_manager.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:famd/src/view_models/app_states.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:logger/logger.dart';

class DownManagerPage extends StatefulWidget {
  const DownManagerPage({super.key});
  @override
  _DownManagerPageState createState() => _DownManagerPageState();
}

class _DownManagerPageState extends State<DownManagerPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任务管理'),
        actions: <Widget>[
          SizedBox(
            width: 60,
            child: IconButton(
              icon: const Icon(Icons.play_arrow),
              tooltip: '开始下载',
              onPressed: () {
                startTask();
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: '重新下载',
              onPressed: () async {
                _taskManager.downFinish();
                await _taskManager.resetTask(_taskCtrl.taskList);
                await _taskCtrl.updateTaskList();
                startTask();
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: '清空任务',
              onPressed: () async {
                deleteAllTask();
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: '下载中'),
            Tab(text: '下载完成'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: GetBuilder<TaskController>(
              builder: (_) => ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: _taskCtrl.taskList.length,
                itemBuilder: (BuildContext context, int index) {
                  M3u8Task task = _taskCtrl.taskList[index];
                  //task.status = 2;
                  if (task.status == 1) {
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
                                color: KONGQUELAN,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: SHANCHAHONG,
                                ),
                                onPressed: () {
                                  deleteTask(task, false);
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const TextWarning(
                                text: '等待下载',
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
                  } else if (task.status == 2) {
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
                                  TextPrimary(
                                      text: _taskCtrl.downStatusInfo.value),
                                ],
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Divider(thickness: 1, height: 0.5),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextInfo(
                                      text:
                                          '速      度：${_taskCtrl.taskInfo.speed}/S',
                                      opacity: 0.4,
                                    ),
                                    TextInfo(
                                      text:
                                          '分 片  数：${_taskCtrl.taskInfo.tsTotal}',
                                      opacity: 0.4,
                                    ),
                                    TextInfo(
                                      text:
                                          '解密状态：${_taskCtrl.taskInfo.tsDecrty}',
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
                                          '下 载 进 度：${_taskCtrl.taskInfo.progress}',
                                      opacity: 0.4,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        const TextInfo(
                                          text: '分片下载数：',
                                          opacity: 0.4,
                                        ),
                                        TextSuccess(
                                          text:
                                              '${_taskCtrl.taskInfo.tsSuccess}',
                                        ),
                                        const TextInfo(
                                          text: ' / ',
                                          opacity: 0.4,
                                        ),
                                        TextDanger(
                                          text: '${_taskCtrl.taskInfo.tsFail}',
                                        ),
                                      ],
                                    ),
                                    TextInfo(
                                      text:
                                          '合 并 状 态：${_taskCtrl.taskInfo.mergeStatus}',
                                      opacity: 0.4,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(thickness: 1, height: 1),
              ),
            ),
          ),
          Center(
            child: GetBuilder<TaskController>(
              builder: (_) => ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: _taskCtrl.finishTaskList.length,
                itemBuilder: (BuildContext context, int index) {
                  M3u8Task task = _taskCtrl.finishTaskList[index];
                  // String statusText = task.status == 3 ? '下载完成' : '下载失败';
                  Widget statusIcon = task.status == 3
                      ? IconButton(
                          icon: const Icon(
                            Icons.play_circle_outline,
                            color: FENLV,
                          ),
                          onPressed: () async {
                            String mp4Path = getMp4Path(task, task.downdir);
                            playerVideo(mp4Path);
                          },
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.restart_alt_outlined,
                            color: SHANCHAHONG,
                          ),
                          onPressed: () async {
                            _taskManager.resetFailTask(task.id!);
                          },
                        );
                  Widget statusText = task.status == 3
                      ? const TextSuccess(text: '下载成功')
                      : TextDanger(text: task.remarks ?? '下载失败');
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
                            statusIcon,
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: SHANCHAHONG,
                              ),
                              onPressed: () {
                                deleteTask(task, true);
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            statusText,
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  final TaskController _taskCtrl = Get.find();
  late final TabController _tabController;
  final logger = Logger();
  final TaskManager _taskManager = TaskManager();
  final textStyle =
      const TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5));

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _tabController = TabController(length: 2, vsync: this);
    await _taskCtrl.updateTaskList();
    await _taskManager.resetTask(_taskCtrl.taskList);
  }

  startTask() {
    _taskManager.startAria2Task();
  }

  deleteAllTask() {
    showConfirmDialog(
      context: context,
      content: "确定要删除所有任务以及本地文件吗？",
      onConfirm: () async {
        await _taskManager.resetTask(_taskCtrl.taskList);
        await clearM3u8Task();
        _taskCtrl.updateTaskList();
        Navigator.of(context).pop();
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }

  deleteTask(M3u8Task task, bool delFile) {
    showConfirmDialog(
      context: context,
      content: "确定要删除此任务以及本地文件吗？",
      onConfirm: () async {
        await deleteM3u8Task(task);
        if (delFile) {
          String mp4Path = taskFullMp4Path(task);
          String tsPath = taskFullTsDir(task);
          deleteFile(mp4Path);
          deleteDir(tsPath);
        }
        await _taskCtrl.updateTaskList();
        Navigator.of(context).pop();
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }
}
