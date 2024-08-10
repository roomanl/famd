import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../common/const.dart';
import 'common_utils.dart';

/// 检查更新
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

/// 版本更新
checkAppVsersion(vJson, context, openDialog) async {
  final currentVersion = await getAppVersion();
  final serverVersion = vJson['version'];
  if (shouldUpdate(currentVersion, serverVersion)) {
    if (!openDialog) {
      EasyLoading.showToast('有新版本');
      return;
    }
    String updateMsg = "";
    updateMsg += "当前版本：v$currentVersion\n";
    updateMsg += "最  新 版：v$serverVersion\n";
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

/// 最新版本提示
latestVersionToast() {
  EasyLoading.showToast('已经是最新版本');
}

bool shouldUpdate(String currentVersion, String serverVersion) {
  List<int> currentParts = currentVersion.split('.').map(int.parse).toList();
  List<int> serverParts = serverVersion.split('.').map(int.parse).toList();
  for (int i = 0; i < currentParts.length && i < serverParts.length; i++) {
    if (currentParts[i] < serverParts[i]) {
      return true;
    } else if (currentParts[i] > serverParts[i]) {
      return false;
    }
  }
  if (currentParts.length < serverParts.length) {
    return true;
  }
  return false;
}
