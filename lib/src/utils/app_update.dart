import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../common/const.dart';
import 'common_utils.dart';

checkAppUpdate(context, openDialog) async {
  if (openDialog) {
    EasyLoading.show(status: '正在检查更新...');
  }
  var res = await http.get(Uri.parse(APP_CHECK_VERSION_URL));
  if (openDialog) {
    EasyLoading.dismiss();
  }
  if (res.statusCode == 200) {
    var vJson = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    checkAppVsersion(vJson, context, openDialog);
  } else if (openDialog) {
    latestVersionToast();
  }
}

checkAppVsersion(vJson, context, openDialog) async {
  final oldVersion = await getAppVersion();
  final newVsersion = vJson['version'];
  if (oldVersion != newVsersion) {
    if (!openDialog) {
      EasyLoading.showToast('有新版本');
      return;
    }
    String updateMsg = "";
    updateMsg += "当前版本：v$oldVersion\n";
    updateMsg += "最  新 版：v$newVsersion\n";
    updateMsg += "更新内容：\n";
    updateMsg += vJson['contents'].join('\n');

    // updateMsg += "更新时间：${vJson['date']}";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('有更新'),
          content: Text(updateMsg),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('更新'),
              onPressed: () {
                openWebUrl(vJson['url']);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else if (openDialog) {
    latestVersionToast();
  }
}

latestVersionToast() {
  EasyLoading.showToast('已经是最新版本');
}
