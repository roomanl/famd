import 'package:famd/src/utils/date/date_utils.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../view_models/app_states.dart';
import '../common/const.dart';
import '../utils/task/task_utils.dart';
import '../models/m3u8_task.dart';
import '../utils/http/http.dart';

class SearchVodResultPage extends StatefulWidget {
  final String vodName;
  final int vodId;
  const SearchVodResultPage(
      {super.key, required this.vodName, required this.vodId});

  @override
  _SearchVodResultPageState createState() => _SearchVodResultPageState();
}

class _SearchVodResultPageState extends State<SearchVodResultPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeCtrl.mainColor.value,
        leading: IconButton(
          color: const Color.fromRGBO(255, 255, 255, 1),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _vodName!,
          style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _buildTabsTitle(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _buildTabView(),
      ),
    );
  }

  String? _vodName;
  int? _vodId;
  late String downPath;
  var m3u8Res = [];
  final _themeCtrl = Get.put(CustomThemeController());
  final _taskCtrl = Get.put(TaskController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _vodName = widget.vodName.replaceAll(" ", "");
    _vodId = widget.vodId;
    _tabController = TabController(length: 0, vsync: this);
    init();
    getVodDetail();
  }

  init() async {
    downPath = await getDownPath();
  }

  getVodDetail() async {
    EasyLoading.show();
    var res = await sslClient()
        .get(Uri.parse(M3U8_DETAIL_SEARCH_API + _vodId.toString()));
    EasyLoading.dismiss();
    if (res.statusCode != 200) {
      EasyLoading.showError('服务器错误！');
      return;
    }
    var dataJson = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    initVodUrlList(dataJson['list'][0]);
  }

  initVodUrlList(vodData) async {
    String vodPlayUrl = vodData['vod_play_url'];
    if (vodPlayUrl.isEmpty) return;
    var vodPlayUrlList = vodPlayUrl.split('\$\$\$');

    var episodes = [];
    for (int i = 0; i < vodPlayUrlList.length; i++) {
      if (vodPlayUrlList[i].isEmpty) continue;
      var vodUrlList = vodPlayUrlList[i].split('#');
      var episode = [];
      for (int j = 0; j < vodUrlList.length; j++) {
        if (vodUrlList[j].isEmpty) continue;
        var vodUrl = vodUrlList[j].split("\$");
        episode.add({'label': vodUrl[0], 'url': vodUrl[1]});
      }
      episodes.add(episode);
    }

    setState(() {
      m3u8Res = episodes;
      _tabController = TabController(length: m3u8Res.length, vsync: this);
    });
  }

  void addTask(episode) async {
    if (episode['url'].toString().isEmpty ||
        !episode['url'].startsWith('http')) {
      EasyLoading.showInfo('${episode.label}m3u8地址失效！');
      return;
    }
    String m3u8name = '$_vodName-${episode["label"]}';
    bool has =
        await hasM3u8Name(_vodName!, episode["label"].replaceAll(" ", ""));
    if (has) {
      EasyLoading.showInfo('$m3u8name,已在列表中！');
      return;
    }
    M3u8Task task = M3u8Task(
        subname: episode["label"].replaceAll(" ", ""),
        m3u8url: episode['url'].replaceAll(" ", ""),
        m3u8name: _vodName!,
        downdir: downPath,
        status: 1,
        createtime: now());
    await insertM3u8Task(task);
    await _taskCtrl.updateTaskList();
    EasyLoading.showToast('$m3u8name加入任务列表！');
  }

  List<Widget> _buildTabsTitle() {
    List<Widget> tabs = [];
    for (int i = 0; m3u8Res.length > i; i++) {
      tabs.add(Tab(text: '资源${i + 1}'));
    }
    return tabs;
  }

  List<Widget> _buildTabView() {
    List<Widget> tabView = [];
    for (int i = 0; m3u8Res.length > i; i++) {
      var episodes = m3u8Res[i];
      List<Widget> gridTiles = [];
      for (int j = 0; episodes.length > j; j++) {
        gridTiles.add(
          OutlinedButton(
            onPressed: () {
              addTask(episodes[j]);
            },
            child: Text(episodes[j]['label']),
          ),
        );
      }
      var grid = SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          spacing: 8.0, // 水平间距
          runSpacing: 8.0,
          children: gridTiles,
        ),
      );

      tabView.add(grid);
    }
    return tabView;
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    _tabController.dispose();
    super.dispose();
  }
}
