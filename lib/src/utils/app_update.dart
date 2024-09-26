import 'dart:convert';

import 'package:famd/src/common/config.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'common_utils.dart';

/// 检查更新
checkAppUpdate(context, openDialog) async {
  if (openDialog) {
    EasyLoading.show(status: '${FamdLocale.checkingUpdate.tr}...');
  }
  var res = await http.get(Uri.parse(FamdConfig.appCheckVersionUrl));
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
      EasyLoading.showToast(FamdLocale.hasNewVersion.tr);
      return;
    }
    String updateMsg = "";
    updateMsg += "${FamdLocale.currentVersion.tr}：v$currentVersion\n";
    updateMsg += "${FamdLocale.latestVersion.tr}：v$serverVersion\n";
    updateMsg += "${FamdLocale.updateContent.tr}：\n";
    updateMsg += vJson['contents'].join('\n');

    // updateMsg += "更新时间：${vJson['date']}";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(FamdLocale.hasUpdate.tr),
          content: Text(updateMsg),
          actions: <Widget>[
            TextButton(
              child: Text(FamdLocale.cancel.tr),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(FamdLocale.update.tr),
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
  EasyLoading.showToast(FamdLocale.isMaxVersion.tr);
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
