import 'package:famd/src/views/home/binding.dart';
import 'package:famd/src/views/home/index.dart';
import 'package:famd/src/views/searchvod/result_binding.dart';
import 'package:famd/src/views/searchvod/result_page.dart';
import 'package:famd/src/views/searchvod/search_binding.dart';
import 'package:famd/src/views/searchvod/search_page.dart';
import 'package:famd/src/views/startaria/binding.dart';
import 'package:famd/src/views/startaria/index.dart';
import 'package:famd/src/views/welcome/binding.dart';
import 'package:famd/src/views/welcome/index.dart';
import 'package:get/get.dart';

class RouteNames {
  static const String root = '/';
  static const String startAria = '/startaria';
  static const String home = '/home';
  static const String setting = '/setting';
  static const String searchVod = '/search/vod';
  static const String searchVodResult = '/search/vod/result';
}

class RoutePages {
  // 列表
  static List<GetPage> list = [
    GetPage(
      name: RouteNames.root,
      page: () => const WelcomPage(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: RouteNames.startAria,
      transition: Transition.fadeIn,
      page: () => const StartAriaPage(),
      binding: StartAriaBinding(),
    ),
    GetPage(
      name: RouteNames.home,
      transition: Transition.fadeIn,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: RouteNames.searchVod,
      page: () => const SearchVodPage(),
      binding: SearchVodBinding(),
    ),
    GetPage(
      name: RouteNames.searchVodResult,
      page: () => const ResultVodPage(),
      binding: ResultVodBinding(),
    ),
  ];
}
