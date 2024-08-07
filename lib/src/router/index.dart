import 'package:famd/src/views/home_page.dart';
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
    ),
  ];
}
