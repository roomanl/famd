import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../entity/M3u8Task.dart';
import '../entity/TaskInfo.dart';
import 'ASEUtil.dart';
import 'Aria2Manager.dart';
import 'SettingConfUtils.dart';
import 'EventBusUtil.dart';
import 'FfmpegUtil.dart';
import 'M3u8Util.dart';
import 'TaskPrefsUtil.dart';
import 'Utils.dart';
import 'FileUtils.dart';

class TaskManager {
  var logger = Logger();
  late bool isDowning = false;
  late bool isDecryptTsing = false;
  late TaskInfo? taskInfo = TaskInfo();
  late M3u8Task tasking;
  late int restCount = 0;
  late String? downPath;

  TaskManager() {
    EventBusUtil().eventBus.on<ListAria2Notifications>().listen((event) {
      listNotifications(event.data);
    });
  }

  restTask(List<M3u8Task> taskList) async {
    Aria2Manager().aria2c.forcePauseAll();
    Aria2Manager().aria2c.purgeDownloadResult();
    Aria2Manager().clearSession();
    for (M3u8Task task in taskList) {
      if (task.status == 2) {
        task.status = 1;
        await updateM3u8Task(task);
      }
    }
  }

  startAria2Task(M3u8Task task) async {
    if (isDowning) return;
    isDowning = true;
    tasking = task;
    EasyLoading.show(status: '正在开始任务...');
    downPath = await getDownPath();
    M3u8Util m3u8 = M3u8Util(m3u8url: task.m3u8url);
    bool success = await m3u8.init();
    if (!success) {
      errDownFinish();
      EventBusUtil().eventBus.fire(DownSuccessEvent());
      return;
    }
    task.iv = m3u8.IV;
    task.keyurl = m3u8.keyUrl;
    task.downdir = downPath;
    task.status = 2;

    List<String> tsList = m3u8.tsList;
    String saveDir = getTsSaveDir(task, downPath);

    taskInfo = TaskInfo();
    taskInfo?.tsTotal = tsList.length;

    List<TsTask>? tsTaskList = [];
    for (int i = 0; i < tsList.length; i++) {
      String url = tsList[i];
      // print(url);
      String filename = '${i.toString().padLeft(4, '0')}.ts';
      TsTask tsTask;
      if (isResetDown(task, downPath, filename)) {
        var res = await Aria2Manager().addUrl(url, filename, saveDir);
        print(res.toString());
        var jsonRes = jsonDecode(res.toString());
        tsTask = TsTask(
            tsName: filename,
            tsUrl: url,
            savePath: saveDir,
            gid: jsonRes['result']);
      } else {
        tsTask =
            TsTask(tsName: filename, tsUrl: url, savePath: saveDir, staus: 2);
      }
      tsTaskList.add(tsTask);
    }
    taskInfo?.tsTaskList = tsTaskList;

    await updateM3u8Task(task);
    updataTaskInfo();
    EventBusUtil().eventBus.fire(TaskInfoEvent(taskInfo));
    EasyLoading.showSuccess('任务启动成功');
  }

  restStartAria2Task() {
    if (restCount > 3) {
      decryptTs();
    }
    EasyLoading.showInfo('第$restCount次重新下载失败文件');
    Aria2Manager().aria2c.forcePauseAll();
    Aria2Manager().aria2c.purgeDownloadResult();
    isDowning = false;
    isDecryptTsing = false;
    startAria2Task(tasking);
    restCount++;
  }

  updataTaskInfo() {
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
      } else {
        decryptTs();
      }
    }
  }

  decryptTs() async {
    if (!isDowning && isDecryptTsing) return;
    isDecryptTsing = true;
    // EasyLoading.showInfo('开始解密ts文件');
    taskInfo?.tsDecrty = '解密中...';
    List<String> decryptTsList = [];
    if (tasking.keyurl!.isNotEmpty) {
      var keyres = await http.get(Uri.parse(tasking.keyurl!));
      if (keyres.statusCode != 200) {
        errDownFinish();
        return;
      }
      String keystr = keyres.body;
      taskInfo?.tsTaskList?.asMap().forEach((index, item) async {
        TsTask? tsTask = taskInfo?.tsTaskList?[index];
        String tsPath = '${getTsSaveDir(tasking, downPath)}/${tsTask!.tsName}';
        String tsSavePath =
            '${getDtsSaveDir(tasking, downPath)}/${tsTask.tsName}';
        bool decryptSuccess =
            aseDecryptTs(tsPath, tsSavePath, keystr.toString(), tasking.iv);
        if (decryptSuccess) {
          // taskInfo?.tsDecrty++;
          decryptTsList.add('file \'$tsSavePath\'');
        }
        // print(decryptSuccess);
        EventBusUtil().eventBus.fire(TaskInfoEvent(taskInfo));
      });
    } else {
      taskInfo?.tsTaskList?.asMap().forEach((index, item) async {
        TsTask? tsTask = taskInfo?.tsTaskList?[index];
        String tsPath = '${getTsSaveDir(tasking, downPath)}/${tsTask!.tsName}';
        decryptTsList.add('file \'$tsPath\'');
      });
    }
    if (decryptTsList.isNotEmpty) {
      String fileListPath =
          '$downPath/${tasking.m3u8name}/${tasking.subname}/file.txt';
      File(fileListPath)
          .writeAsStringSync(decryptTsList.join('\n'), flush: true);
      taskInfo?.tsDecrty = '解密完成';
      mergeTs(downPath, fileListPath);
    } else {
      taskInfo?.tsDecrty = '解密失败';
      errDownFinish();
    }
  }

  mergeTs(downPath, fileListPath) async {
    // EasyLoading.showInfo('开始合并ts文件');
    taskInfo?.mergeStatus = '合并中...';
    EventBusUtil().eventBus.fire(TaskInfoEvent(taskInfo));
    String mp4Path =
        '$downPath/${tasking.m3u8name}/${tasking.m3u8name}-${tasking.subname}.mp4';
    bool success = await tsMergeTs(fileListPath, mp4Path);
    if (success) {
      taskInfo?.mergeStatus = '合并完成';
      // EasyLoading.showInfo('合并成功');
      tasking.status = 3;
      updateM3u8Task(tasking);
      // String folderPath = '$downPath/${tasking.m3u8name}/${tasking.subname}';
      // deleteDir(folderPath);
      downFinish();
      EventBusUtil().eventBus.fire(DownSuccessEvent());
    } else {
      errDownFinish();
    }
  }

  errDownFinish() async {
    EasyLoading.showError('${tasking.m3u8name}-${tasking.subname}下载失败');
    tasking.status = 4;
    await updateM3u8Task(tasking);
    downFinish();
    EventBusUtil().eventBus.fire(DownSuccessEvent());
  }

  downFinish() {
    isDowning = false;
    isDecryptTsing = false;
    restCount = 0;
  }

  listNotifications(String data) {
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
      }
    } else if (jsonData['method'] == 'aria2.removeDownloadResult') {}
    updataTaskInfo();
    EventBusUtil().eventBus.fire(TaskInfoEvent(taskInfo));
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

  String getTsSaveDir(M3u8Task task, String? downPath) {
    return getDtsDir(task, downPath, 'ts');
  }

  String getDtsSaveDir(M3u8Task task, String? downPath) {
    return getDtsDir(task, downPath, 'dts');
  }

  String getDtsDir(M3u8Task task, String? downPath, String dirname) {
    String saveDir = '$downPath/${task.m3u8name}/${task.subname}/$dirname';
    createDir(saveDir);
    return saveDir;
  }
}