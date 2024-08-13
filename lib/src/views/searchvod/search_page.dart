import 'package:famd/src/components/bar/title_bar.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/views/searchvod/widgets/search/vod_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'search_controller.dart';

class SearchVodPage extends GetView<SearchVodController> {
  const SearchVodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    return WinTitleBar(
      useThemeColor: true,
      autoHide: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeCtrl.mainColor.value,
          leadingWidth: 40,
          leading: IconButton(
            color: const Color.fromRGBO(255, 255, 255, 1),
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          title: SizedBox(
            height: 45,
            child: SearchBar(
              controller: controller.serachController,
              hintText: FamdLocale.searchIputHint.tr,
              elevation: WidgetStateProperty.all(0),
              onSubmitted: (value) {
                controller.searchVodList();
              },
              leading: IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: controller.searchVodList,
              ),
              trailing: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: controller.cleanInput,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: controller.searchVodList,
                child: Text(
                  FamdLocale.search.tr,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: const VodListWidget(),
      ),
    );
  }
}
