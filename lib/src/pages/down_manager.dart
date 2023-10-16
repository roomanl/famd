import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:logger/logger.dart';
import '../entity/m3u8_task.dart';
import '../states/app_states.dart';

import '../utils/task_prefs_util.dart';
import '../utils/task_manager.dart';

class DownManagerPage extends StatefulWidget {
  const DownManagerPage({super.key});
  @override
  _DownManagerPageState createState() => _DownManagerPageState();
}

class _DownManagerPageState extends State<DownManagerPage>
    with TickerProviderStateMixin {
  final TaskController _taskCtrl = Get.find();
  late final TabController _tabController;
  final logger = Logger();
  final TaskManager _taskManager = TaskManager();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _tabController = TabController(length: 2, vsync: this);
    await _taskCtrl.updateTaskList();
    await _taskManager.restTask(_taskCtrl.taskList);
  }

  startTask() {
    _taskManager.startAria2Task();
  }

  deleteTask(M3u8Task task, bool delFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('您确定要删除吗？'),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('确定'),
              onPressed: () async {
                await deleteM3u8Task(task);
                if (delFile) {
                  String mp4Path =
                      '${task.downdir}/${task.m3u8name}/${task.m3u8name}-${task.subname}.mp4';
                  File file = File(mp4Path);
                  if (file.existsSync()) {
                    file.deleteSync();
                  }
                  String tsPath =
                      '${task.downdir}/${task.m3u8name}/${task.subname}';
                  try {
                    Directory directory = Directory(tsPath);
                    directory.deleteSync(recursive: true);
                  } catch (e) {
                    logger.e(e);
                  }
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
                await _taskManager.restTask(_taskCtrl.taskList);
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
                await _taskManager.restTask(_taskCtrl.taskList);
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
                  if (task.status == 1) {
                    return Container(
                      height: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '${task.m3u8name}-${task.subname}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              const Text('等待下载'),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  deleteTask(task, false);
                                },
                              ),
                            ],
                          ),
                          Text(
                            task.m3u8url,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(100, 0, 0, 0)),
                          ),
                        ],
                      ),
                    );
                  } else if (task.status == 2) {
                    return Container(
                      // height: 50,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  const Text('下载中'),
                                ],
                              ),
                              Text(
                                task.m3u8url,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(100, 0, 0, 0)),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    '速      度：${_taskCtrl.taskInfo.speed}/S'),
                              ),
                              Expanded(
                                child:
                                    Text('下载进度：${_taskCtrl.taskInfo.progress}'),
                              ),
                              Expanded(
                                child: const Text(''),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    '分 片  数：${_taskCtrl.taskInfo.tsTotal}'),
                              ),
                              Expanded(
                                child: Text(
                                    '分片下载数：${_taskCtrl.taskInfo.tsSuccess}'),
                              ),
                              Expanded(
                                child:
                                    Text('分片失败数：${_taskCtrl.taskInfo.tsFail}'),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child:
                                    Text('解密状态：${_taskCtrl.taskInfo.tsDecrty}'),
                              ),
                              Expanded(
                                child: Text(
                                    '合并状态：${_taskCtrl.taskInfo.mergeStatus}'),
                              ),
                              Expanded(
                                child: const Text(''),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
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
                  String statusText = task.status == 3 ? '下载完成' : '下载失败';
                  return Container(
                    height: 50,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${task.m3u8name}-${task.subname}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Text(statusText),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteTask(task, true);
                          },
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
