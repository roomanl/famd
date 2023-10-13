import 'package:flutter/widgets.dart';
import '../entity/task_info.dart';

class TaskController extends ChangeNotifier {
  TaskController({required this.taskInfo});
  TaskInfo taskInfo = TaskInfo();
  updateTaskInfo(info) {
    taskInfo = info;
    notifyListeners();
  }
}
