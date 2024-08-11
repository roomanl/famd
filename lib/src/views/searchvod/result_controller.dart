import 'dart:convert';

import 'package:famd/src/common/config.dart';
import 'package:famd/src/controller/task.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/utils/date/date_utils.dart';
import 'package:famd/src/utils/http/http.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ResultVodController extends GetxController
    with GetTickerProviderStateMixin {
  final _taskCtrl = Get.find<TaskController>();
  late TabController tabController;
  RxString vodName = ''.obs;
  RxList m3u8Res = [].obs;
  String vodId = '';
  String downPath = '';

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  @override
  void onReady() {
    super.onReady();
  }

  _init() async {
    tabController = TabController(length: 0, vsync: this);
    updateArguments(Get.parameters);
    downPath = await getDownPath();
    getVodDetail();
  }

  getVodDetail() async {
    EasyLoading.show();
    var res = await sslClient()
        .get(Uri.parse(FamdConfig.m3u8DetailSearchApi + vodId));
    EasyLoading.dismiss();
    if (res.statusCode != 200) {
      EasyLoading.showError(FamdLocale.serverError.tr);
      return;
    }
    var dataJson = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    var list = dataJson['list'];
    if (!list.isEmpty) {
      initVodUrlList(list[0]);
    }
  }

  initVodUrlList(vodData) {
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
    m3u8Res.value = episodes;
    tabController = TabController(length: m3u8Res.length, vsync: this);
    update();
  }

  addTask(episode) async {
    String episodeUrl = episode["url"];
    if (episodeUrl.toString().isEmpty || !episodeUrl.startsWith('http')) {
      EasyLoading.showInfo('${episode.label}${FamdLocale.urlInvalid.tr}');
      return;
    }
    String episodeName = episode["label"].replaceAll(" ", "");
    episodeUrl = episodeUrl.replaceAll(" ", "");
    String m3u8Name = '$vodName-$episodeName';
    bool has = await hasM3u8Name(vodName.value, episodeName);
    if (has) {
      EasyLoading.showInfo('$m3u8Name,${FamdLocale.alreadyInList.tr}');
      return;
    }
    M3u8Task task = M3u8Task(
        subname: episodeName,
        m3u8url: episodeUrl,
        m3u8name: vodName.value,
        downdir: downPath,
        status: 1,
        createtime: now());
    await insertM3u8Task(task);
    await _taskCtrl.updateTaskList();
    EasyLoading.showToast('$m3u8Name${FamdLocale.addTaskList.tr}');
  }

  updateArguments(arguments) {
    vodId = arguments['vodId'];
    vodName.update((val) {
      vodName.value = arguments['vodName'];
    });
  }
}
