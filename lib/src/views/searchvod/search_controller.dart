import 'dart:convert';

import 'package:famd/src/common/config.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/utils/http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SearchVodController extends GetxController {
  final serachController = SearchController();
  RxList voidDataList = RxList();
  RxString msgText = FamdLocale.searchIputHint.tr.obs;
  @override
  void onReady() {
    super.onReady();
  }

  searchVodList() async {
    if (serachController.text.isEmpty) return;
    EasyLoading.show(status: '${FamdLocale.inSearch.tr}...');
    var res = await sslClient()
        .get(Uri.parse(FamdConfig.m3u8WdSearchApi + serachController.text));
    EasyLoading.dismiss();
    // print(res.body);
    if (res.statusCode != 200) {
      EasyLoading.showError(FamdLocale.serverError.tr);
      return;
    }
    var dataJson = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    var list = dataJson['list'];
    // print(list.toString());
    updateVoidDataList(list);
    if (voidDataList.isEmpty) {
      updateMsgText(FamdLocale.noSearchResult.tr);
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
