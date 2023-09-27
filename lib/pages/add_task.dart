import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../entity/M3u8Task.dart';
import '../utils/EventBusUtil.dart';
import '../utils/TaskPrefsUtil.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _urlcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('添加任务'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 160,
              child: TextField(
                // initialValue: settingConf[ARIA2_URL],
                controller: _urlcontroller,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText:
                      '请输入视频链接，格式为：xxx\$http://abc.m3u8,多个链接时，请确保每行只有一个链接。(xxx可以是第01集、第12期、高清版、1080P等)',
                ),
              ),
            ),
            // SizedBox(height: 20),
            SizedBox(
              height: 70,
              child: TextField(
                // initialValue: settingConf[ARIA2_URL],
                controller: _namecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '请输入具体视频名称，例如：西游记',
                ),
              ),
            ),
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
    );
  }
// 第70集$https://hd.ijycnd.com/play/PdRDwjza/index.m3u8
// 第71集$https://hd.ijycnd.com/play/zbqm5Byb/index.m3u8

  @override
  void initState() {
    super.initState();
    _urlcontroller.text = '';
    _namecontroller.text = '';
  }

  void addTask() async {
    if (_urlcontroller.text.isEmpty || _namecontroller.text.isEmpty) {
      EasyLoading.showInfo('URL或名称不能为空');
      return;
    }

    List<String> urls = _urlcontroller.text.split('\n');
    for (String url in urls) {
      List<String> info = url.split('\$');
      if (info.length < 2) {
        EasyLoading.showInfo('$url链接格式不正确，跳过！');
        continue;
      }
      String m3u8name = '${_namecontroller.text}-${info[0]}';
      bool has = await hasM3u8Name(_namecontroller.text, info[0].trim());
      if (has) {
        EasyLoading.showInfo('$m3u8name,已在列表中，跳过！');
        continue;
      }
      M3u8Task task = M3u8Task(
          id: uuid.v4(),
          subname: info[0].trim(),
          m3u8url: info[1].trim(),
          m3u8name: _namecontroller.text.trim(),
          status: 1);
      insertM3u8Task(task);
    }
    EventBusUtil().eventBus.fire(AddTaskEvent());
    EasyLoading.showSuccess('添加成功');
    Navigator.pop(context);
    // print(_urlcontroller.text);
    // print(_namecontroller.text);
    // M3u8Util(m3u8url: _urlcontroller.text);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
