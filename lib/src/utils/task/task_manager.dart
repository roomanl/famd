import 'dart:convert';
import 'dart:io';
import 'package:famd/src/entity/ts_info.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:logger/logger.dart';
import '../../entity/m3u8_task.dart';
import '../../entity/task_info.dart';
import '../../states/app_states.dart';
import '../m3u8/ase_util.dart';
import '../aria2/aria2_manager.dart';
import '../setting_conf_utils.dart';
import '../m3u8/ffmpeg_util.dart';
import '../m3u8/m3u8_util.dart';
import '../task/task_utils.dart';
import '../common_utils.dart';
import '../file_utils.dart';

class TaskManager {
  final _logger = Logger();
  late M3u8Task _tasking;
  late M3u8Util _m3u8util;
  late String _downPath;
  bool _isDowning = false;
  bool _isDecryptTsing = false;
  bool _isMergeTsing = false;
  TaskInfo _taskInfo = TaskInfo();
  int _restCount = 0;

  ///记录下载回调时间
  late int notificationsTime = 0;
  final _taskCtrl = Get.put(TaskController());

  TaskManager() {
    _taskCtrl.aria2Notifications.listen((data) {
      listNotifications(data);
    });
  }

  restTask(List<M3u8Task> taskList) async {
    await Aria2Manager().forcePauseAll();
    await Aria2Manager().purgeDownloadResult();
    Aria2Manager().clearSession();
    for (M3u8Task task in taskList) {
      if (task.getStatus == 2) {
        task.setStatus = 1;
        await updateM3u8Task(task);
      }
    }
    _taskCtrl.updateTaskList();
  }

  startAria2Task({M3u8Task? task}) async {
    if (_isDowning) return;
    _taskInfo = TaskInfo();
    if (task == null) {
      if (_taskCtrl.taskList.isEmpty) {
        EasyLoading.showInfo('列表中没有任务');
        return;
      }
      for (M3u8Task task in _taskCtrl.taskList) {
        if (task.getStatus == 2) {
          EasyLoading.showInfo('已经在下载中');
          return;
        }
      }
      _taskCtrl.updateTaskInfo(_taskInfo);
      _taskCtrl.updateDownStatusInfo("正在开始任务...");
    }
    _isDowning = true;
    _tasking = task ?? _taskCtrl.taskList[0];
    _tasking.setStatus = 2;
    await updateM3u8Task(_tasking);
    _taskCtrl.updateTaskList();
    _downPath = await getDownPath();

    _m3u8util = M3u8Util();
    bool success = await _m3u8util.parseByTask(_tasking);
    if (!success) {
      errDownFinish();
      return;
    }
    _tasking.setIv = _m3u8util.getIv;
    _tasking.setKeyurl = _m3u8util.getKeyUrl;
    _tasking.setKeyvalue = _m3u8util.getKeyValue;
    _tasking.setDowndir = _downPath;
    await updateM3u8Task(_tasking);

    List<TsInfo> tsList = _m3u8util.getTsList;
    String saveDir = getTsSaveDir(_tasking, _downPath);

    _taskInfo.tsTotal = tsList.length;

    List<TsTask>? tsTaskList = [];
    for (int i = 0; i < tsList.length; i++) {
      String url = tsList[i].getTsurl;
      // print(url);
      String filename = tsList[i].getFilename;
      TsTask tsTask;
      if (isResetDown(_tasking, _downPath, filename)) {
        String? gid = await Aria2Manager().addUrl(url, filename, saveDir);
        if (gid != null) {
          tsTask =
              TsTask(tsName: filename, tsUrl: url, savePath: saveDir, gid: gid);
        } else {
          tsTask =
              TsTask(tsName: filename, tsUrl: url, savePath: saveDir, staus: 3);
        }
      } else {
        tsTask =
            TsTask(tsName: filename, tsUrl: url, savePath: saveDir, staus: 2);
      }
      tsTaskList.add(tsTask);
    }
    _taskInfo.tsTaskList = tsTaskList;

    await updateM3u8Task(_tasking);
    _updataTaskInfo();
    _taskCtrl.updateTaskInfo(_taskInfo);
    _taskCtrl.updateDownStatusInfo("下载中...");
    // EasyLoading.showSuccess('任务启动成功');
  }

  _restStartAria2Task() async {
    //有下载失败的分片，重试5次，超过5次不再重试
    if (_restCount >= 5) {
      await _decryptTs();
      return;
    }
    // EasyLoading.showInfo('第$restCount次重新下载失败文件');
    await Aria2Manager().forcePauseAll();
    await Aria2Manager().purgeDownloadResult();
    _isDowning = false;
    _tasking.setStatus = 1;
    _restCount++;
    _taskCtrl.updateDownStatusInfo("重试$_restCount");
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

    _taskInfo.speed = bytesToSize(Aria2Manager().downSpeed);

    if (tsSuccess + tsFail == tsTotal) {
      if (tsFail > 0) {
        _restStartAria2Task();
      } else if (tsSuccess > 0) {
        await _decryptTs();
      } else {
        errDownFinish();
      }
    }
  }

  _decryptTs() async {
    if (!_isDowning || _isDecryptTsing || _isMergeTsing) return;
    _isDecryptTsing = true;
    // EasyLoading.showInfo('开始解密ts文件');
    _taskCtrl.updateDownStatusInfo("解密中...");
    _taskInfo.tsDecrty = '解密中...';
    List<String> decryptTsList = [];
    if (!(_tasking.getKeyurl ?? "").isEmpty) {
      String? keystr = _tasking.getKeyvalue;
      if ((keystr ?? "").isEmpty) {
        keystr = await _m3u8util.getKeyValueStr(_tasking.getKeyurl);
      }
      if ((keystr ?? "").isEmpty) {
        errDownFinish();
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
              tsPath, tsSavePath, keystr.toString(), _tasking.getIv);
        } else if (Platform.isAndroid) {
          ///flutter解码方式在android特别慢，这里调用android原生来解码
          decryptSuccess = await androidAseDecryptTs(
              tsPath, tsSavePath, keystr.toString(), _tasking.getIv);
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
      _taskInfo.tsDecrty = '解密完成';
      _taskCtrl.updateDownStatusInfo("解密完成");
      mergeTs(fileListPath);
    } else {
      _taskInfo.tsDecrty = '解密失败';
      _taskCtrl.updateDownStatusInfo("解密失败");
      errDownFinish();
    }
  }

  mergeTs(fileListPath) async {
    _isMergeTsing = true;
    _taskCtrl.updateDownStatusInfo("合并中...");
    _taskInfo.mergeStatus = '合并中...';
    _taskCtrl.updateTaskInfo(_taskInfo);
    String mp4Path = getMp4Path(_tasking, _downPath);
    bool success = await tsMergeTs(fileListPath, mp4Path);
    if (success) {
      _taskCtrl.updateDownStatusInfo("合并完成");
      _taskInfo.mergeStatus = '合并完成';
      _tasking.setStatus = 3;
      await updateM3u8Task(_tasking);
      String folderPath = getDtsDir(_tasking, _downPath, '');
      // '$_downPath/${_tasking.m3u8name}/${_tasking.subname}';
      deleteDir(folderPath);
      downFinish();
      await _taskCtrl.updateTaskList();
      startAria2Task();
    } else {
      errDownFinish();
    }
  }

  errDownFinish() async {
    EasyLoading.showError('${_tasking.getM3u8name}-${_tasking.getSubname}下载失败');
    _tasking.setStatus = 4;
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
        _taskInfo.tsTaskList?.asMap().forEach((index, item) {
          if (_taskInfo.tsTaskList?[index].gid == gid) {
            taskIndex = index;
            return;
          }
        });
        // logger.i(taskIndex);
        if (taskIndex < 0) return;
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
