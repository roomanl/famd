// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaskInfo {
  String? speed;
  String? progress;
  int? tsTotal;
  int? tsSuccess;
  int? tsFail;
  int tsDecrty;
  String? mergeStatus;
  List<TsTask>? tsTaskList;
  String? get getSpeed => this.speed;

  set setSpeed(String? speed) => this.speed = speed;

  get getProgress => this.progress;

  set setProgress(progress) => this.progress = progress;

  get getTsTotal => this.tsTotal;

  set setTsTotal(tsTotal) => this.tsTotal = tsTotal;

  get getTsSuccess => this.tsSuccess;

  set setTsSuccess(tsSuccess) => this.tsSuccess = tsSuccess;

  get getTsFail => this.tsFail;

  set setTsFail(tsFail) => this.tsFail = tsFail;

  get getTsDecrty => this.tsDecrty;

  set setTsDecrty(tsDecrty) => this.tsDecrty = tsDecrty;

  get getMergeStatus => this.mergeStatus;

  set setMergeStatus(mergeStatus) => this.mergeStatus = mergeStatus;

  get getTsTaskList => this.tsTaskList;

  set setTsTaskList(tsTaskList) => this.tsTaskList = tsTaskList;
  TaskInfo(
      {this.mergeStatus = '等待合并',
      this.progress = '0%',
      this.speed = '0M/S',
      this.tsDecrty = 0,
      this.tsFail = 0,
      this.tsSuccess = 0,
      this.tsTotal = 0,
      this.tsTaskList = const []});

  @override
  String toString() {
    return 'TaskInfo{speed=$speed, progress=$progress, tsTotal=$tsTotal, tsSuccess=$tsSuccess, tsFail=$tsFail, tsDecrty=$tsDecrty, mergeStatus=$mergeStatus, tsTaskList=$tsTaskList}';
  }
}

class TsTask {
  String tsName;
  String? gid;
  String? tsUrl;
  String? savePath;
  int? staus;

  get getSavePath => this.savePath;

  set setSavePath(savePath) => this.savePath = savePath;

  String? get getTsName => this.tsName;

  set setTsName(String? tsName) => this.tsName = tsName!;

  get getGid => this.gid;

  set setGid(gid) => this.gid = gid;

  get getTsUrl => this.tsUrl;

  set setTsUrl(tsUrl) => this.tsUrl = tsUrl;

  get getStaus => this.staus;

  set setStaus(staus) => this.staus = staus;

  TsTask({
    required this.tsName,
    this.gid,
    this.tsUrl,
    this.savePath,
    this.staus,
  });

  @override
  String toString() {
    return 'TsTask{tsName=$tsName, gid=$gid, tsUrl=$tsUrl, savePath=$savePath, staus=$staus}';
  }
}
