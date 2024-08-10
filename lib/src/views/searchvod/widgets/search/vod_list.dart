import 'package:famd/src/views/searchvod/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'vod_item.dart';

class VodListWidget extends GetView<SearchVodController> {
  const VodListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchVodController>(
      builder: (_) {
        return Obx(
          () => controller.voidDataList.isEmpty
              ? Center(
                  child: Text(controller.msgText.value),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.voidDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var vod = controller.voidDataList[index];
                    return VodItem(vod: vod);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(thickness: 1, height: 1),
                ),
        );
      },
    );
  }
}
