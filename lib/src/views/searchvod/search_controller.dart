import 'dart:convert';

import 'package:famd/src/common/const.dart';
import 'package:famd/src/utils/http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SearchVodController extends GetxController {
  final serachController = SearchController();
  RxList voidDataList = RxList();
  RxString msgText = '请输入关键字进行搜索'.obs;
  @override
  void onReady() {
    super.onReady();
  }

  searchVodList() async {
    if (serachController.text.isEmpty) return;
    EasyLoading.show(status: '搜索中...');
    var res = await sslClient()
        .get(Uri.parse(M3U8_WD_SEARCH_API + serachController.text));
    EasyLoading.dismiss();
    // print(res.body);
    if (res.statusCode != 200) {
      EasyLoading.showError('服务器错误！');
      return;
    }
    var dataJson = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    var list = dataJson['list'];
    // print(list.toString());
    updateVoidDataList(list);
    if (voidDataList.isEmpty) {
      updateMsgText('没有搜索到相关结果');
    }
  }

  openDetails(vod) {
    Get.toNamed(
      "/search/vod/result",
      parameters: {
        "vodName": vod['vod_name'].toString(),
        "vodId": vod['vod_id'].toString(),
      },
    );
  }

  updateVoidDataList(list) {
    voidDataList.value = list;
    update();
  }

  updateMsgText(text) {
    msgText.update((val) {
      msgText.value = text;
    });
  }

  cleanInput() {
    serachController.text = '';
  }

  @override
  void onClose() {
    super.onClose();
    EasyLoading.dismiss();
  }
}
