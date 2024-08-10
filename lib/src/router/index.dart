import 'package:famd/src/views/home/binding.dart';
import 'package:famd/src/views/home/index.dart';
import 'package:famd/src/views/searchvod/result_binding.dart';
import 'package:famd/src/views/searchvod/result_page.dart';
import 'package:famd/src/views/searchvod/search_binding.dart';
import 'package:famd/src/views/searchvod/search_page.dart';
import 'package:famd/src/views/welcome/binding.dart';
import 'package:famd/src/views/welcome/index.dart';
import 'package:get/get.dart';

class RoutePages {
  // 列表
  static List<GetPage> list = [
    GetPage(
      name: "/",
      page: () => const WelcomPage(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: "/home",
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: "/search/vod",
      page: () => const SearchVodPage(),
      binding: SearchVodBinding(),
    ),
    GetPage(
      name: "/search/vod/result",
      page: () => const ResultVodPage(),
      binding: ResultVodBinding(),
    ),
  ];
}
