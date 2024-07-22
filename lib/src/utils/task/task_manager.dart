import 'dart:convert';
import 'dart:io';
import 'package:famd/src/entity/ts_info.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
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
  var logger = Logger();
  late bool isDowning = false;
  late bool isDecryptTsing = false;
  late bool isMergeTsing = false;
  late TaskInfo? taskInfo = TaskInfo();
  late M3u8Task tasking;
  late int restCount = 0;
  late String? downPath;

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
      if (task.status == 2) {
        task.status = 1;
        await updateM3u8Task(task);
      }
    }
    _taskCtrl.updateTaskList();
  }

  startAria2Task({M3u8Task? task}) async {
    if (isDowning) return;
    taskInfo = TaskInfo();
    if (task == null) {
      if (_taskCtrl.taskList.isEmpty) {
        EasyLoading.showInfo('列表中没有任务');
        return;
      }
      for (M3u8Task task in _taskCtrl.taskList) {
        if (task.status == 2) {
          EasyLoading.showInfo('已经在下载中');
          return;
        }
      }
      _taskCtrl.updateTaskInfo(taskInfo);
      _taskCtrl.updateDownStatusInfo("正在开始任务...");
    }
    isDowning = true;
    tasking = task ?? _taskCtrl.taskList[0];
    tasking.status = 2;
    await updateM3u8Task(tasking);
    _taskCtrl.updateTaskList();
    downPath = await getDownPath();

    M3u8Util m3u8 = M3u8Util(m3u8url: tasking.m3u8url);
    bool success = await m3u8.parseByTask(tasking);
    if (!success) {
      errDownFinish();
      return;
    }
    tasking.iv = m3u8.IV;
    tasking.keyurl = m3u8.keyUrl;
    tasking.downdir = downPath;

    List<TsInfo> tsList = m3u8.tsList;
    String saveDir = getTsSaveDir(tasking, downPath);

    taskInfo?.tsTotal = tsList.length;

    List<TsTask>? tsTaskList = [];
    for (int i = 0; i < tsList.length; i++) {
      String url = tsList[i].getTsurl;
      // print(url);
      String filename = tsList[i].getFilename;
      TsTask tsTask;
      if (isResetDown(tasking, downPath, filename)) {
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
    taskInfo?.tsTaskList = tsTaskList;

    await updateM3u8Task(tasking);
    updataTaskInfo();
    _taskCtrl.updateTaskInfo(taskInfo);
    _taskCtrl.updateDownStatusInfo("下载中...");
    // EasyLoading.showSuccess('任务启动成功');
  }

  restStartAria2Task() async {
    //有下载失败的分片，重试5次，超过5次不再重试
    if (restCount >= 5) {
      await decryptTs();
      return;
    }
    // EasyLoading.showInfo('第$restCount次重新下载失败文件');
    await Aria2Manager().forcePauseAll();
    await Aria2Manager().purgeDownloadResult();
    isDowning = false;
    tasking.status = 1;
    restCount++;
    _taskCtrl.updateDownStatusInfo("重试$restCount");
    startAria2Task(task: tasking);
  }

  updataTaskInfo() async {
    if (!isDowning || isDecryptTsing || isMergeTsing) return;
    double progress = 0;
    int tsSuccess = 0;
    int tsFail = 0;
    taskInfo?.tsTaskList?.asMap().forEach((index, item) {
      TsTask? tsTask = taskInfo?.tsTaskList?[index];
      if (tsTask?.staus == 2) {
        tsSuccess++;
      } else if (tsTask?.staus == 3) {
        tsFail++;
      }
    });
    taskInfo?.tsSuccess = tsSuccess;
    taskInfo?.tsFail = tsFail;
    int tsTotal = taskInfo?.tsTotal ?? 0;
    progress = tsSuccess / tsTotal;
    taskInfo?.progress =
        tsTotal == 0 ? '0%' : '${(progress * 100).toStringAsFixed(2)}%';

    taskInfo?.speed = bytesToSize(Aria2Manager().downSpeed);

    if (tsSuccess + tsFail == tsTotal) {
      if (tsFail > 0) {
        restStartAria2Task();
      } else if (tsSuccess > 0) {
        await decryptTs();
      } else {
        errDownFinish();
      }
    }
  }

  decryptTs() async {
    if (!isDowning || isDecryptTsing || isMergeTsing) return;
    isDecryptTsing = true;
    // EasyLoading.showInfo('开始解密ts文件');
    _taskCtrl.updateDownStatusInfo("解密中...");
    taskInfo?.tsDecrty = '解密中...';
    List<String> decryptTsList = [];
    if (tasking.keyurl!.isNotEmpty) {
      var keyres = await http.get(Uri.parse(tasking.keyurl!));
      if (keyres.statusCode != 200) {
        errDownFinish();
        return;
      }
      String keystr = keyres.body;
      for (var index = 0; index < taskInfo!.tsTaskList!.length; index++) {
        // taskInfo?.tsTaskList?.asMap().forEach((index, item) async {
        TsTask? tsTask = taskInfo?.tsTaskList?[index];
        String tsPath = '${getTsSaveDir(tasking, downPath)}/${tsTask!.tsName}';
        String tsSavePath =
            '${getDtsSaveDir(tasking, downPath)}/${tsTask.tsName}';
        bool decryptSuccess = false;
        if (Platform.isWindows || Platform.isLinux) {
          decryptSuccess = await aseDecryptTs(
              tsPath, tsSavePath, keystr.toString(), tasking.iv);
        } else if (Platform.isAndroid) {
          ///flutter解码方式在android特别慢，这里调用android原生来解码
          decryptSuccess = await androidAseDecryptTs(
              tsPath, tsSavePath, keystr.toString(), tasking.iv);
        }
        if (decryptSuccess) {
          // taskInfo?.tsDecrty++;
          decryptTsList.add('file \'$tsSavePath\'');
        }
        taskInfo?.tsDecrty = (index + 1).toString();
        _taskCtrl.updateTaskInfo(taskInfo);
        // });
      }
    } else {
      taskInfo?.tsTaskList?.asMap().forEach((index, item) async {
        TsTask? tsTask = taskInfo?.tsTaskList?[index];
        String tsPath = '${getTsSaveDir(tasking, downPath)}/${tsTask!.tsName}';
        decryptTsList.add('file \'$tsPath\'');
      });
    }
    if (decryptTsList.isNotEmpty) {
      String fileListPath = getTsListTxtPath(tasking, downPath);
      File(fileListPath)
          .writeAsStringSync(decryptTsList.join('\n'), flush: true);
      taskInfo?.tsDecrty = '解密完成';
      _taskCtrl.updateDownStatusInfo("解密完成");
      mergeTs(downPath, fileListPath);
    } else {
      taskInfo?.tsDecrty = '解密失败';
      _taskCtrl.updateDownStatusInfo("解密失败");
      errDownFinish();
    }
  }

  mergeTs(downPath, fileListPath) async {
    isMergeTsing = true;
    _taskCtrl.updateDownStatusInfo("合并中...");
    taskInfo?.mergeStatus = '合并中...';
    _taskCtrl.updateTaskInfo(taskInfo);
    String mp4Path = getMp4Path(tasking, downPath);
    bool success = await tsMergeTs(fileListPath, mp4Path);
    if (success) {
      _taskCtrl.updateDownStatusInfo("合并完成");
      taskInfo?.mergeStatus = '合并完成';
      tasking.status = 3;
      await updateM3u8Task(tasking);
      String folderPath = getDtsDir(tasking, downPath, '');
      // '$downPath/${tasking.m3u8name}/${tasking.subname}';
      deleteDir(folderPath);
      downFinish();
      await _taskCtrl.updateTaskList();
      startAria2Task();
    } else {
      errDownFinish();
    }
  }

  errDownFinish() async {
    EasyLoading.showError('${tasking.m3u8name}-${tasking.subname}下载失败');
    tasking.status = 4;
    await updateM3u8Task(tasking);
    downFinish();
    await _taskCtrl.updateTaskList();
    startAria2Task();
  }

  downFinish() {
    isDowning = false;
    isDecryptTsing = false;
    isMergeTsing = false;
    restCount = 0;
    notificationsTime = 0;
  }

  listNotifications(String data) {
    if (data.contains('check-down-status')) {
      ///检查下载状态是否卡住
      ///最后一次下载完回调的时间记录和当前时间相减，如果如果>30S判断为卡住
      ///在下载中不在解密中并且notificationsTime有时间才重试
      if (DateTime.now().millisecondsSinceEpoch - notificationsTime > 30000 &&
          notificationsTime != 0 &&
          !isDecryptTsing &&
          !isMergeTsing &&
          isDowning) {
        logger.i("卡住");

        ///卡住的话重试
        restStartAria2Task();
      }
    } else {
      ///每次下载完回调纪录一次时间
      notificationsTime = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> jsonData = jsonDecode(data);
      if (data.contains('aria2.onDown')) {
        String gid = jsonData['params'][0]['gid'];
        int taskIndex = -1;
        taskInfo?.tsTaskList?.asMap().forEach((index, item) {
          if (taskInfo?.tsTaskList?[index].gid == gid) {
            taskIndex = index;
            return;
          }
        });
        // logger.i(taskIndex);
        if (taskIndex < 0) return;
        if (jsonData['method'] == 'aria2.onDownloadStart') {
          taskInfo?.tsTaskList?[taskIndex].staus = 1;
        } else if (jsonData['method'] == 'aria2.onDownloadPause') {
          taskInfo?.tsTaskList?[taskIndex].staus = 3;
        } else if (jsonData['method'] == 'aria2.onDownloadError') {
          taskInfo?.tsTaskList?[taskIndex].staus = 3;
          // logger.i('下载失败：' + data);
        } else if (jsonData['method'] == 'aria2.onDownloadComplete') {
          taskInfo?.tsTaskList?[taskIndex].staus = 2;
          // logger.i('下载完成：' + jsonData['params'][0]['gid']);
        } else {
          taskInfo?.tsTaskList?[taskIndex].staus = 3;
        }
        updataTaskInfo();
        _taskCtrl.updateTaskInfo(taskInfo);
      } else if (jsonData['method'] == 'aria2.removeDownloadResult') {}
    }
  }

  bool isResetDown(M3u8Task task, String? downPath, String tsName) {
    String tsPath = '${getTsSaveDir(tasking, downPath)}/$tsName';
    if (!fileExistsSync(tsPath)) {
      return true;
    }
    String tsTemPath = '${getTsSaveDir(tasking, downPath)}/$tsName.aria2';
    if (fileExistsSync(tsTemPath)) {
      deleteFile(tsPath);
      deleteFile(tsTemPath);
      return true;
    }
    return false;
  }
}
