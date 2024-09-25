import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class M3U8WebPage extends GetView<M3U8WebController> {
  const M3U8WebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(FamdLocale.m3u8Resource.tr),
      ),
      body: Obx(
        () =>
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.all(5),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Wrap(spacing: 8.0, runSpacing: 8.0, children: [
            //           ...controller.resourceList.map(
            //             (item) => Card.outlined(
            //               child: InkWell(
            //                 onTap: () {
            //                   controller.openWeb(item);
            //                 },
            //                 child: SizedBox(
            //                   width: 160,
            //                   height: 90,
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(10),
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         const Icon(Icons.movie_filter),
            //                         TextInfo(
            //                           text: item['label'],
            //                           fontSize: 16.0,
            //                         ),
            //                         TextInfo(
            //                           text: item['info'],
            //                           opacity: 0.5,
            //                           fontSize: 10,
            //                           overflow: TextOverflow.ellipsis,
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ]),
            //       ],
            //     ),
            //   ),
            // ),
            GridView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: controller.resourceList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            crossAxisCount: controller.crossAxisCount.value,
            childAspectRatio: 2.0,
          ),
          itemBuilder: (context, index) => Card.outlined(
            child: InkWell(
              onTap: () {
                controller.openWeb(controller.resourceList[index]);
              },
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie_filter),
                      TextInfo(
                        text: controller.resourceList[index]['label'],
                        fontSize: 16.0,
                      ),
                      TextInfo(
                        text: controller.resourceList[index]['info'],
                        opacity: 0.5,
                        fontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
