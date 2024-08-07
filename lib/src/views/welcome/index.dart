import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'widgets/widgets.dart';

class WelcomPage extends GetView<WelcomeController> {
  const WelcomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WelcomeController>(
      builder: (_) {
        return const Scaffold(
          body: BackgroundWidget(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: AppTileWidget(),
                    ),
                  ),
                  Expanded(
                    child: StartBtnWidget(),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AppVersion(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
