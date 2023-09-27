import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:window_manager/window_manager.dart';
import '../entity/M3u8Task.dart';
import '../entity/TaskInfo.dart';
import '../utils/Aria2Util.dart';
import '../utils/EventBusUtil.dart';

import '../utils/TaskPrefsUtil.dart';
import '../utils/TaskUtil.dart';
import './add_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WindowListener {
  late final TabController _tabController;
  final logger = Logger();
  late List<M3u8Task> taskList = [];
  late List<M3u8Task> finishTaskList = [];
  late TaskInfo? taskInfo = TaskInfo();

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() {
    Aria2Util().closeServer();
  }

  init() async {
    EventBusUtil().eventBus.on<AddTaskEvent>().listen((event) {
      updateList();
    });
    EventBusUtil().eventBus.on<DownSuccessEvent>().listen((event) async {
      await updateList();
      startTask();
    });
    EventBusUtil().eventBus.on<TaskInfoEvent>().listen((event) {
      setState(() {
        taskInfo = event.taskInfo;
      });
    });
    _tabController = TabController(length: 2, vsync: this);
    await updateList();
    await restTask(taskList);
    updateList();
  }

  startTask() async {
    if (taskList.length == 0) {
      EasyLoading.showInfo('列表中没有任务');
      return;
    }
    for (M3u8Task task in taskList) {
      if (task.status == 2) {
        EasyLoading.showInfo('已经在下载中');
        return;
      }
    }
    await Aria2Util().startAria2Task(taskList[0]);
    await updateList();
  }

  updateList() async {
    List<M3u8Task> list = await getM3u8TaskList();
    // logger.i(list.toString());
    setState(() {
      taskList = [];
      finishTaskList = [];
      for (M3u8Task task in list) {
        if (task.status == 1 || task.status == 2) {
          taskList.add(task);
        } else {
          finishTaskList.add(task);
        }
      }
    });
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
                updateList();
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
        // title: const Text('home'),
        actions: <Widget>[
          SizedBox(
            width: 60,
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const AddTaskPage()));
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                startTask();
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                Aria2Util().downReset();
                await restTask(taskList);
                await updateList();
                startTask();
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () async {
                await restTask(taskList);
                await clearM3u8Task();
                updateList();
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Aria2Util().addUrl('https://7-zip.org/a/7z2301-x64.exe',
                //     '222.exe', 'D:/Aria2-M3u8/download');
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                // ...
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: '下载中',
            ),
            Tab(
              text: '下载完成',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: taskList.length,
              itemBuilder: (BuildContext context, int index) {
                M3u8Task task = taskList[index];
                if (task.status == 1) {
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
                        const Text('等待下载'),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteTask(task, false);
                          },
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
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${task.m3u8name}-${task.subname}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            const Text('下载中'),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('速    度：${taskInfo?.speed}/S'),
                            ),
                            Expanded(
                              child: Text('下载进度：${taskInfo?.progress}'),
                            ),
                            Expanded(
                              child: const Text(''),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('分片数：${taskInfo?.tsTotal}'),
                            ),
                            Expanded(
                              child: Text('分片下载数：${taskInfo?.tsSuccess}'),
                            ),
                            Expanded(
                              child: Text('分片失败数：${taskInfo?.tsFail}'),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('解码数：${taskInfo?.tsDecrty}'),
                            ),
                            Expanded(
                              child: Text('合并状态：${taskInfo?.mergeStatus}'),
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
          Center(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: finishTaskList.length,
              itemBuilder: (BuildContext context, int index) {
                M3u8Task task = finishTaskList[index];
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
                      const Text('下载完成'),
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
        ],
      ),
    );
  }
}
