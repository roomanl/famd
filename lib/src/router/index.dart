import 'package:famd/src/views/addtask/binding.dart';
import 'package:famd/src/views/addtask/index.dart';
import 'package:famd/src/views/home/binding.dart';
import 'package:famd/src/views/home/index.dart';
import 'package:famd/src/views/search_page.dart';
import 'package:famd/src/views/welcome/binding.dart';
import 'package:famd/src/views/welcome/index.dart';
import 'package:get/get.dart';

class RoutePages {
  // 列表
  static List<GetPage> list = [
    GetPage(
      name: "/",
      page: () => const WelcomPage(),
      // binding: WelcomeBinding(),
      bindings: [WelcomeBinding()],
    ),
    GetPage(
      name: "/home",
      page: () => const HomePage(),
      bindings: [HomeBinding()],
    ),
    GetPage(
      name: "/search",
      page: () => const SearchPage(),
    ),
  ];
}
