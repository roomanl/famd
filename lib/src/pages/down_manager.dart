import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:logger/logger.dart';
import '../common/color.dart';
import '../entity/m3u8_task.dart';
import '../states/app_states.dart';

import '../utils/common_utils.dart';
import '../utils/file_utils.dart';
import '../utils/task/task_utils.dart';
import '../utils/task/task_manager.dart';

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
                await _taskManager.resetTask(_taskCtrl.taskList);
                await clearM3u8Task();
                _taskCtrl.updateTaskList();
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
                  // task.status = 2;
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
                                child: Text(
                                  '${task.m3u8name}-${task.subname}',
                                  style: const TextStyle(fontSize: 16),
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
                          // Text(
                          //   task.m3u8url,
                          //   style: const TextStyle(
                          //       fontSize: 12,
                          //       color: Color.fromARGB(100, 0, 0, 0)),
                          // ),
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
                                    child: Text(
                                      '${task.m3u8name}-${task.subname}',
                                      style: const TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.7),
                                          fontSize: 16),
                                    ),
                                  ),
                                  Text(
                                    _taskCtrl.downStatusInfo.value,
                                    style: const TextStyle(
                                        fontSize: 12, color: KONGQUELAN),
                                  ),
                                ],
                              ),
                              // Text(
                              //   task.m3u8url,
                              //   style: const TextStyle(
                              //       fontSize: 12,
                              //       color: Color.fromARGB(100, 0, 0, 0)),
                              // ),
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
                                    Text(
                                        '速      度：${_taskCtrl.taskInfo.speed}/S',
                                        style: textStyle),
                                    Text('分 片  数：${_taskCtrl.taskInfo.tsTotal}',
                                        style: textStyle),
                                    Text('解密状态：${_taskCtrl.taskInfo.tsDecrty}',
                                        style: textStyle),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                        '下 载 进 度：${_taskCtrl.taskInfo.progress}',
                                        style: textStyle),
                                    Row(
                                      children: <Widget>[
                                        Text('分片下载数：', style: textStyle),
                                        Text('${_taskCtrl.taskInfo.tsSuccess}',
                                            style: const TextStyle(
                                                fontSize: 12, color: FENLV)),
                                        Text(' / ', style: textStyle),
                                        Text('${_taskCtrl.taskInfo.tsFail}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: SHANCHAHONG)),
                                      ],
                                    ),
                                    Text(
                                        '合 并 状 态：${_taskCtrl.taskInfo.mergeStatus}',
                                        style: textStyle),
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
                      ? const Text('成功',
                          style: TextStyle(fontSize: 12, color: FENLV))
                      : const Text('失败',
                          style: TextStyle(fontSize: 12, color: SHANCHAHONG));
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${task.m3u8name}-${task.subname}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(0, 0, 0, 0.7),
                            ),
                          ),
                        ),
                        statusText,
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

  deleteTask(M3u8Task task, bool delFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('您确定要删除吗？'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: () async {
                await deleteM3u8Task(task);
                if (delFile) {
                  String mp4Path =
                      '${task.downdir}/${task.m3u8name}/${task.m3u8name}-${task.subname}.mp4';
                  String tsPath =
                      '${task.downdir}/${task.m3u8name}/${task.subname}';
                  deleteFile(mp4Path);
                  deleteDir(tsPath);
                }
                await _taskCtrl.updateTaskList();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
