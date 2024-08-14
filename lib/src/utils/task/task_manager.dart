import 'dart:convert';
import 'dart:io';
import 'package:famd/src/controller/app.dart';
import 'package:famd/src/controller/task.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/models/ts_info.dart';
import 'package:famd/src/utils/date/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../models/m3u8_task.dart';
import '../../models/task_info.dart';
import '../m3u8/ase_util.dart';
import '../aria2/aria2_manager.dart';
import '../setting_conf_utils.dart';
import '../m3u8/ffmpeg_util.dart';
import '../m3u8/m3u8_util.dart';
import '../task/task_utils.dart';
import '../common_utils.dart';
import '../file/file_utils.dart';

class TaskManager {
  final _logger = Logger();
  late M3u8Task _tasking;
  late M3u8Util _m3u8util;
  late String _downPath;
  bool _isParseM3u8ing = false; //是否解析中
  bool _isRestStart = false; //是否重试中
  bool _isDowning = false; //是否下载中
  bool _isDecryptTsing = false; //是否解密中
  bool _isMergeTsing = false; //是否合并中
  TaskInfo _taskInfo = TaskInfo();
  int _restCount = 0;
  var _tsGidIndex = {};

  ///记录下载回调时间
  late int notificationsTime = 0;
  final _taskCtrl = Get.find<TaskController>();
  final _appCtrl = Get.find<AppController>();

  TaskManager() {
    _taskCtrl.aria2Notifications.listen((data) {
      listNotifications(data);
    });
    _appCtrl.aria2Speed.listen((speed) {
      _taskInfo.speed = bytesToSize(speed);
    });
  }
  cleanAria2() async {
    // await Aria2Manager().forcePauseAll();
    // await Aria2Manager().purgeDownloadResult();
    // await Aria2Manager().tellWaiting();
    await Aria2Manager().cleanAria2AllTask();
    // await Aria2Manager().clearSession();
  }

  resetTask(List<M3u8Task> taskList) async {
    await cleanAria2();
    for (M3u8Task task in taskList) {
      if (task.status == 2) {
        task.status = 1;
        await updateM3u8Task(task);
      }
    }
    _taskCtrl.updateTaskList();
  }

  resetFailTask(int id) async {
    M3u8Task? task = await getM3u8TaskById(id);
    if (task != null) {
      task.status = 1;
      task.createtime = now();
      await updateM3u8Task(task);
      _taskCtrl.updateTaskList();
      EasyLoading.showInfo('任务已重新添加到下载中');
    }
  }

  startAria2Task({M3u8Task? task}) async {
    // _taskCtrl.updateDownStatusInfo("正在开始任务...");
    // return;
    if (_isDowning) {
      EasyLoading.showInfo(FamdLocale.alreadyDownloading.tr);
      _isParseM3u8ing = false;
      return;
    }
    _isRestStart = false;
    _isParseM3u8ing = true;
    _taskInfo = TaskInfo();
    if (task == null) {
      if (_taskCtrl.taskList.isEmpty) {
        EasyLoading.showInfo(FamdLocale.listNoTask.tr);
        _isParseM3u8ing = false;
        return;
      }
      bool downing = _taskCtrl.taskList.any((task) => task.status == 2);
      debugPrint(downing.toString());
      if (downing) {
        EasyLoading.showInfo(FamdLocale.alreadyDownloading.tr);
        _isParseM3u8ing = false;
        return;
      }
      _taskCtrl.updateTaskInfo(_taskInfo);
      _taskCtrl.updateDownStatusInfo(FamdLocale.startingTask.tr);
    }
    _isDowning = true;
    _tasking = task ?? _taskCtrl.taskList[0];
    _tasking.status = 2;
    await updateM3u8Task(_tasking);
    _taskCtrl.updateTaskList();
    _downPath = await getDownPath();

    _m3u8util = M3u8Util();
    bool success = await _m3u8util.parseByTask(_tasking);
    if (!success) {
      errDownFinish(FamdLocale.parseFail.tr);
      return;
    }
    _tasking.iv = _m3u8util.iv;
    _tasking.keyurl = _m3u8util.keyUrl;
    _tasking.keyvalue = _m3u8util.keyValue;
    _tasking.downdir = _downPath;
    await updateM3u8Task(_tasking);

    List<TsInfo> tsList = _m3u8util.tsList;
    String saveDir = getTsSaveDir(_tasking, _downPath);

    _taskInfo.tsTotal = tsList.length;
    _taskCtrl.updateTaskInfo(_taskInfo);
    _taskInfo.tsTaskList = [];
    _tsGidIndex = {};
    await cleanAria2();
    for (int i = 0; i < tsList.length; i++) {
      String url = tsList[i].tsurl;
      // print(url);
      String filename = tsList[i].filename;
      TsTask tsTask = TsTask(tsName: filename, tsUrl: url, savePath: saveDir);
      if (isResetDown(_tasking, _downPath, filename)) {
        String? gid = await Aria2Manager().addUrl(url, filename, saveDir);
        // debugPrint("gid==>:$gid");
        if ((gid ?? "").isNotEmpty) {
          tsTask.gid = gid;
          _tsGidIndex[gid] = i;
        } else {
          tsTask.staus = 3;
        }
      } else {
        tsTask.staus = 2;
      }
      _taskInfo.tsTaskList?.add(tsTask);
    }
    await updateM3u8Task(_tasking);
    _isParseM3u8ing = false;
    _updataTaskInfo();
    _taskCtrl.updateTaskInfo(_taskInfo);
    _taskCtrl.updateDownStatusInfo("${FamdLocale.downloading.tr}...");
  }

  _restStartAria2Task() async {
    //解析中，不重试
    if (_isParseM3u8ing || _isRestStart) return;
    _isRestStart = true;
    //有下载失败的分片，重试5次，超过5次不再重试
    if (_restCount >= 5) {
      await _decryptTs();
      return;
    }
    // EasyLoading.showInfo('第$restCount次重新下载失败文件');
    await cleanAria2();
    _isDowning = false;
    _tasking.status = 1;
    _restCount = _restCount + 1;
    _taskCtrl.updateDownStatusInfo("${FamdLocale.tryAgain.tr}$_restCount");
    //print("重试$_restCount");
    _isRestStart = false;
    startAria2Task(task: _tasking);
  }

  _updataTaskInfo() async {
    if (!_isDowning || _isDecryptTsing || _isMergeTsing) return;
    double progress = 0;
    int tsSuccess = 0;
    int tsFail = 0;
    _taskInfo.tsTaskList?.asMap().forEach((index, item) {
      TsTask? tsTask = _taskInfo.tsTaskList?[index];
      if (tsTask?.staus == 2) {
        tsSuccess++;
      } else if (tsTask?.staus == 3) {
        tsFail++;
      }
    });
    _taskInfo.tsSuccess = tsSuccess;
    _taskInfo.tsFail = tsFail;
    int tsTotal = _taskInfo.tsTotal ?? 0;
    progress = tsSuccess / tsTotal;
    _taskInfo.progress =
        tsTotal == 0 ? '0%' : '${(progress * 100).toStringAsFixed(2)}%';
    // _updateSpeed();
    //不在解析中，才执行
    // print(tsSuccess + tsFail == tsTotal);
    // print(!_isParseM3u8ing);
    if (tsSuccess + tsFail == tsTotal && !_isParseM3u8ing) {
      if (tsFail > 0) {
        _restStartAria2Task();
      } else if (tsSuccess > 0) {
        await _decryptTs();
      } else {
        errDownFinish(FamdLocale.downFail.tr);
      }
    }
  }

  _updateSpeed() {
    _taskInfo.speed = bytesToSize(Aria2Manager().downSpeed);
  }

  _decryptTs() async {
    if (!_isDowning || _isDecryptTsing || _isMergeTsing) return;
    _isDecryptTsing = true;
    // EasyLoading.showInfo('开始解密ts文件');
    _taskCtrl.updateDownStatusInfo("${FamdLocale.decrypting.tr}...");
    _taskInfo.tsDecrty = '${FamdLocale.decrypting.tr}...';
    List<String> decryptTsList = [];
    if ((_tasking.keyurl ?? "").isNotEmpty) {
      String? keystr = _tasking.keyvalue;
      if ((keystr ?? "").isEmpty) {
        keystr = await _m3u8util.keyValueStr(_tasking.keyurl);
      }
      if ((keystr ?? "").isEmpty) {
        errDownFinish(FamdLocale.decrypFail.tr);
        return;
      }
      for (var index = 0; index < _taskInfo.tsTaskList!.length; index++) {
        // _taskInfo.tsTaskList?.asMap().forEach((index, item) async {
        TsTask? tsTask = _taskInfo.tsTaskList?[index];
        String tsPath =
            '${getTsSaveDir(_tasking, _downPath)}/${tsTask!.tsName}';
        String tsSavePath =
            '${getDtsSaveDir(_tasking, _downPath)}/${tsTask.tsName}';
        bool decryptSuccess = false;
        if (Platform.isWindows || Platform.isLinux) {
          decryptSuccess = await aseDecryptTs(
              tsPath, tsSavePath, keystr.toString(), _tasking.iv);
        } else if (Platform.isAndroid) {
          ///flutter解码方式在android特别慢，这里调用android原生来解码
          decryptSuccess = await androidAseDecryptTs(
              tsPath, tsSavePath, keystr.toString(), _tasking.iv);
        }
        if (decryptSuccess) {
          // _taskInfo.tsDecrty++;
          decryptTsList.add('file \'$tsSavePath\'');
        }
        _taskInfo.tsDecrty = (index + 1).toString();
        _taskCtrl.updateTaskInfo(_taskInfo);
        // });
      }
    } else {
      _taskInfo.tsTaskList?.asMap().forEach((index, item) async {
        TsTask? tsTask = _taskInfo.tsTaskList?[index];
        String tsPath =
            '${getTsSaveDir(_tasking, _downPath)}/${tsTask!.tsName}';
        decryptTsList.add('file \'$tsPath\'');
      });
    }
    if (decryptTsList.isNotEmpty) {
      String fileListPath = getTsListTxtPath(_tasking, _downPath);
      File(fileListPath)
          .writeAsStringSync(decryptTsList.join('\n'), flush: true);
      _taskInfo.tsDecrty = FamdLocale.decrypFinish.tr;
      _taskCtrl.updateDownStatusInfo(FamdLocale.decrypFinish.tr);
      mergeTs(fileListPath);
    } else {
      _taskInfo.tsDecrty = FamdLocale.decrypFail.tr;
      _taskCtrl.updateDownStatusInfo(FamdLocale.decrypFail.tr);
      errDownFinish(FamdLocale.decrypFail.tr);
    }
  }

  mergeTs(fileListPath) async {
    _isMergeTsing = true;
    _taskCtrl.updateDownStatusInfo("${FamdLocale.mergeing.tr}...");
    _taskInfo.mergeStatus = '${FamdLocale.mergeing.tr}...';
    _taskCtrl.updateTaskInfo(_taskInfo);
    String mp4Path = getMp4Path(_tasking, _downPath);
    bool success = await tsMergeTs(fileListPath, mp4Path);
    if (success) {
      _taskCtrl.updateDownStatusInfo(FamdLocale.mergeFinish.tr);
      _taskInfo.mergeStatus = FamdLocale.mergeFinish.tr;
      _tasking.status = 3;
      _tasking.filesize = getFileSize(mp4Path);
      await updateM3u8Task(_tasking);
      String folderPath = getDtsDir(_tasking, _downPath, '');
      // '$_downPath/${_tasking.m3u8name}/${_tasking.subname}';
      deleteDir(folderPath);
      downFinish();
      await _taskCtrl.updateTaskList();
      startAria2Task();
    } else {
      errDownFinish(FamdLocale.mergeFail.tr);
    }
  }

  errDownFinish(String? remarks) async {
    EasyLoading.showError(
        '${_tasking.m3u8name}-${_tasking.subname}${FamdLocale.downFail.tr}');
    _tasking.status = 4;
    _tasking.remarks = remarks;
    await updateM3u8Task(_tasking);
    downFinish();
    await _taskCtrl.updateTaskList();
    startAria2Task();
  }

  downFinish() {
    _isDowning = false;
    _isDecryptTsing = false;
    _isMergeTsing = false;
    _restCount = 0;
    notificationsTime = 0;
  }

  listNotifications(String data) {
    if (data.contains('check-down-status')) {
      ///检查下载状态是否卡住
      ///最后一次下载完回调的时间记录和当前时间相减，如果如果>30S判断为卡住
      ///在下载中不在解密中并且notificationsTime有时间才重试
      if (DateTime.now().millisecondsSinceEpoch - notificationsTime > 30000 &&
          notificationsTime != 0 &&
          !_isDecryptTsing &&
          !_isMergeTsing &&
          _isDowning) {
        _logger.i("卡住");

        ///卡住的话重试
        _restStartAria2Task();
      }
    } else {
      ///每次下载完回调纪录一次时间
      notificationsTime = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> jsonData = jsonDecode(data);
      if (data.contains('aria2.onDown')) {
        String gid = jsonData['params'][0]['gid'];
        int taskIndex = -1;
        if (_tsGidIndex[gid] != null) {
          taskIndex = _tsGidIndex[gid];
          //print(taskIndex);
        } else {
          _taskInfo.tsTaskList?.asMap().forEach((index, item) {
            if (_taskInfo.tsTaskList?[index].gid == gid) {
              taskIndex = index;
              return;
            }
          });
        }
        // logger.i(taskIndex);
        if (taskIndex >= 0) {
          if (jsonData['method'] == 'aria2.onDownloadStart') {
            _taskInfo.tsTaskList?[taskIndex].staus = 1;
          } else if (jsonData['method'] == 'aria2.onDownloadPause') {
            _taskInfo.tsTaskList?[taskIndex].staus = 3;
          } else if (jsonData['method'] == 'aria2.onDownloadError') {
            _taskInfo.tsTaskList?[taskIndex].staus = 3;
            // logger.i('下载失败：' + data);
          } else if (jsonData['method'] == 'aria2.onDownloadComplete') {
            _taskInfo.tsTaskList?[taskIndex].staus = 2;
            // logger.i('下载完成：' + jsonData['params'][0]['gid']);
          } else {
            _taskInfo.tsTaskList?[taskIndex].staus = 3;
          }
          _updataTaskInfo();
          _taskCtrl.updateTaskInfo(_taskInfo);
        }
      } else if (jsonData['method'] == 'aria2.removeDownloadResult') {}
    }
  }

  bool isResetDown(M3u8Task task, String? downPath, String tsName) {
    String tsPath = '${getTsSaveDir(_tasking, downPath)}/$tsName';
    if (!fileExistsSync(tsPath)) {
      return true;
    }
    String tsTemPath = '${getTsSaveDir(_tasking, downPath)}/$tsName.aria2';
    if (fileExistsSync(tsTemPath)) {
      deleteFile(tsPath);
      deleteFile(tsTemPath);
      return true;
    }
    return false;
  }
}
