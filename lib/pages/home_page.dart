import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import '../DB/server/M3u8TaskServer.dart';
import '../DB/entity/M3u8Task.dart';
import '../common/TaskInfo.dart';
import '../common/const.dart';
import '../utils/Aria2Util.dart';
import '../utils/EventBusUtil.dart';
import '../utils/TaskUtil.dart';

import './add_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;
  final logger = Logger();
  late List<M3u8Task> taskList = [];
  late TaskInfo? taskInfo = TaskInfo();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    EventBusUtil().eventBus.on<AddTaskEvent>().listen((event) {
      updateList();
    });
    EventBusUtil().eventBus.on<TaskInfoEvent>().listen((event) {
      setState(() {
        taskInfo = event.taskInfo;
      });
    });
    _tabController = TabController(length: 2, vsync: this);
    updateList();
  }

  startTask() async {
    if (taskList.length == 0) {
      EasyLoading.showInfo('列表中没有任务');
      return;
    }
    // for (M3u8Task task in taskList) {
    //   if (task.status == 2) {
    //     EasyLoading.showInfo('已经在下载中');
    //     return;
    //   }
    // }
    await startAria2Task(taskList[0]);
    updateList();
  }

  updateList() async {
    List<M3u8Task> list = await findAllM3u8Task();
    // logger.i(list.toString());
    setState(() {
      taskList = [];
      for (M3u8Task task in list) {
        if (task.status == 1 || task.status == 2) {
          taskList.add(task);
        }
      }
    });
  }

  deleteTask(task) {
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
              onPressed: () {
                deleteM3u8TaskById(task.id!);
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                            deleteTask(task);
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
                              child: Text('速    度：${taskInfo?.speed}'),
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
                              child: const Text('解码数：等待解码'),
                            ),
                            Expanded(
                              child: const Text('合并状态：等待合并'),
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
            child: Text("下载完成"),
          ),
        ],
      ),
    );
  }
}
