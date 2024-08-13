import 'package:famd/src/controller/input_focus.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AddTaskPage extends GetView<AddTaskController> {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final focusCtrl = Get.find<InputFocusController>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(FamdLocale.addTask.tr),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              TextField(
                controller: controller.urlTextController,
                maxLines: 5,
                autofocus: false,
                focusNode: focusCtrl.cleanAddTaskInputFocus(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: FamdLocale.addTaskInputUrlHint.tr,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.nameTextController,
                autofocus: false,
                focusNode: focusCtrl.cleanAddTaskInputFocus(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: FamdLocale.addTaskInptNameHint.tr,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                // height: 50,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.addTask,
                        child: Text(FamdLocale.add.tr),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
