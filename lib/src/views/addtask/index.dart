import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AddTaskPage extends GetView<AddTaskController> {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final appCtrl = Get.find<AppController>();
    return GetBuilder<AddTaskController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('添加任务'),
          ),
          body: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: controller.urlTextController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          '请输入视频链接，格式为：xxx\$http://abc.m3u8,多个链接时，请确保每行只有一个链接。(xxx可以是第01集、第12期、高清版、1080P等)',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller.nameTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入具体视频名称，例如：西游记',
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
                            child: const Text('添加'),
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
      },
    );
  }
}
