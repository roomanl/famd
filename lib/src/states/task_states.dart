import 'package:get/state_manager.dart';
import '../entity/task_info.dart';

class TaskController extends GetxController {
  Rx<TaskInfo> taskInfo = TaskInfo().obs;
  updateTaskInfo(info) {
    taskInfo.update((val) {
      val?.speed = info.speed;
      val?.progress = info.progress;
      val?.tsTotal = info.tsTotal;
      val?.tsSuccess = info.tsSuccess;
      val?.tsFail = info.tsFail;
      val?.tsDecrty = info.tsDecrty;
      val?.mergeStatus = info.mergeStatus;
      val?.tsTaskList = info.tsTaskList;
    });
  }
}
