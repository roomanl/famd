class TaskInfo {
  String? speed;
  String? progress;
  int? tsTotal;
  int? tsSuccess;
  int? tsFail;
  String? tsDecrty;
  String? mergeStatus;
  List<TsTask>? tsTaskList;

  TaskInfo(
      {this.mergeStatus = '等待合并',
      this.progress = '0%',
      this.speed = '0',
      this.tsDecrty = '等待解密',
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
