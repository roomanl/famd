import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputFocusController extends GetxController {
  late final FocusNode addTaskInputFocusNode;

  @override
  void onInit() {
    super.onInit();
    addTaskInputFocusNode = FocusNode();
  }

  @override
  void onReady() {
    super.onReady();
  }

  cleanAddTaskInputFocus() {
    // debugPrint("cleanAddTaskInputFocus");
    addTaskInputFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
