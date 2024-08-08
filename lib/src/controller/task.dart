import 'package:famd/src/models/m3u8_task.dart';
import 'package:famd/src/models/task_info.dart';
import 'package:famd/src/utils/task/task_utils.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  RxInt taskLength = 0.obs;
  List<M3u8Task> taskList = [];
  RxList<M3u8Task> finishTaskList = RxList();
  RxString downStatusInfo = "".obs;
  RxString aria2Notifications = "".obs;
  TaskInfo taskInfo = TaskInfo();
  @override
  void onReady() {
    super.onReady();
    print("TaskController onReady");
    updateTaskList();
  }

  updateTaskList() async {
    List<M3u8Task> list = await getM3u8TaskList();
    taskList = [];
    finishTaskList = RxList();
    for (M3u8Task task in list) {
      if (task.status == 1 || task.status == 2) {
        taskList.add(task);
      } else {
        finishTaskList.add(task);
      }
    }
    updateTaskLength();
    // update();
  }

  updateTaskLength() {
    taskLength.update((val) {
      taskLength.value = taskList.length;
    });
  }

  updateTaskInfo(info) {
    taskInfo = info;
    update();
  }

  updateDownStatusInfo(String info) {
    downStatusInfo.update((val) {
      downStatusInfo.value = info;
    });
  }

  updateAria2Notifications(String info) {
    aria2Notifications.update((val) {
      aria2Notifications.value = info;
    });
  }
}
