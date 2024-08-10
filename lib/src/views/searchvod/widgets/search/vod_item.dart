import 'package:famd/src/components/text/text_info.dart';
import 'package:famd/src/views/searchvod/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VodItem extends GetView<SearchVodController> {
  final Map vod;
  const VodItem({
    Key? key,
    required this.vod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.openDetails(vod);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextInfo(
              text: vod['vod_name'],
              fontSize: 16,
            ),
            Row(
              children: <Widget>[
                _buildTag(vod['type_name']),
                _buildTag(vod['vod_year'] + '年'),
                _buildTag(vod['vod_remarks']),
                // _buildTag(vod['vod_time']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(text) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 3, end: 10),
      child: TextInfo(
        text: text,
        fontSize: 12,
        opacity: 0.4,
      ),
    );
  }
}
