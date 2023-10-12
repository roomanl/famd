import 'package:flutter/material.dart';

import '../common/const.dart';
import 'add_task_page.dart';
import 'appinfo_page.dart';
import 'down_manager.dart';
import 'setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            _buildLeftNavigation(),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: PageView(
                controller: _pageController,
                allowImplicitScrolling: true,
                children: const [
                  AddTaskPage(),
                  DownManagerPage(),
                  SettingPage(),
                  AppinfoPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final PageController _pageController = PageController(initialPage: 1);
  final List<NavigationRailDestination> destinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.add),
      selectedIcon: Icon(Icons.add),
      label: Text('添加任务'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.list),
      selectedIcon: Icon(Icons.list),
      label: Text('任务管理'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings),
      selectedIcon: Icon(Icons.settings),
      label: Text('设置'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.info),
      selectedIcon: Icon(Icons.info),
      label: Text('关于'),
    ),
  ];
  int _selectedIndex = 1;
  static const Color textColor = Color(0xffcfd1d7);
  static const Color activeColor = Colors.blue;
  static const TextStyle labelStyle =
      TextStyle(color: textColor, fontSize: 11, fontFamily: 'FangYuan2');

  Widget _buildLeftNavigation() {
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      backgroundColor: mainColor,
      unselectedIconTheme: const IconThemeData(color: textColor),
      selectedIconTheme: const IconThemeData(color: activeColor),
      unselectedLabelTextStyle: labelStyle,
      selectedLabelTextStyle: labelStyle,
      onDestinationSelected: _onDestinationSelected,
      destinations: destinations,
      selectedIndex: _selectedIndex,
      leading: IconButton(
        icon:
            Image.asset('lib/resources/images/logo.png', width: 40, height: 40),
        onPressed: () {},
      ),
    );
  }

  void _onDestinationSelected(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }
}
