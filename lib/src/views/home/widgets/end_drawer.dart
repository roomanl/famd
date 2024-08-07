import 'package:famd/src/views/home/controller.dart';
import 'package:famd/src/views/home/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeEndDrawerWidget extends GetView<HomeController> {
  const HomeEndDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: controller.handleScreenChanged,
      selectedIndex: -1,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Image.asset('lib/resources/images/logo.png',
                    width: 40, height: 40),
              ),
              Text(
                'Famd M3U8下载器免费版',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        ...controller.destinations.map(
          (NavDestination destination) {
            return NavigationDrawerDestination(
              label: Text(destination.label),
              icon: destination.icon,
            );
          },
        ),
        const NavigationDrawerDestination(
          label: Text('检查更新'),
          icon: Icon(Icons.update_rounded),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
      ],
    );
  }
}
