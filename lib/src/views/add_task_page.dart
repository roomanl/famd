import 'package:famd/src/utils/setting_conf_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../models/m3u8_task.dart';
import '../view_models/app_states.dart';
import '../utils/task/task_utils.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _urlcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: const Text('添加任务'),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              TextField(
                // initialValue: settingConf[ARIA2_URL],
                controller: _urlcontroller,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText:
                      '请输入视频链接，格式为：xxx\$http://abc.m3u8,多个链接时，请确保每行只有一个链接。(xxx可以是第01集、第12期、高清版、1080P等)',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                // initialValue: settingConf[ARIA2_URL],
                controller: _namecontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '请输入具体视频名称，例如：西游记',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                // height: 50,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          addTask();
                        },
                        child: const Text('添加'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  final _appCtrl = Get.put(AppController());
  final _taskCtrl = Get.put(TaskController());
  late String downPath;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    downPath = await getDownPath();
  }

  void addTask() async {
    if (_urlcontroller.text.isEmpty || _namecontroller.text.isEmpty) {
      EasyLoading.showInfo('URL或名称不能为空');
      return;
    }
    List<String> urls = _urlcontroller.text.split('\n');
    for (String url in urls) {
      List<String> info = url.split('\$');
      if (info.length != 2) {
        EasyLoading.showInfo('$url链接格式不正确！');
        return;
      }
      if (!info[1].startsWith('http')) {
        EasyLoading.showInfo('${info[1]}不是有效的m3u8地址（只支持http或https的M3U8地址）');
        return;
      }
      String m3u8name = '${_namecontroller.text}-${info[0]}';
      bool has =
          await hasM3u8Name(_namecontroller.text, info[0].replaceAll(" ", ""));
      if (has) {
        EasyLoading.showInfo('$m3u8name,已在列表中！');
        return;
      }
      M3u8Task task = M3u8Task(
          subname: info[0].replaceAll(" ", ""),
          m3u8url: info[1]
              .replaceAll(" ", "")
              .replaceAll("\r\n", "")
              .replaceAll("\r", "")
              .replaceAll("\n", ""),
          m3u8name: _namecontroller.text.replaceAll(" ", ""),
          downdir: downPath,
          status: 1);
      await insertM3u8Task(task);
    }
    await _taskCtrl.updateTaskList();
    _appCtrl.updatePageIndex(1);
    _urlcontroller.clear();
    _namecontroller.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    EasyLoading.showSuccess('添加成功');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
