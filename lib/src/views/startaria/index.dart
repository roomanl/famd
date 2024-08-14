import 'package:famd/src/components/app_title.dart';
import 'package:famd/src/components/app_version.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'widgets/widgets.dart';

class StartAriaPage extends GetView<StartAriaController> {
  const StartAriaPage({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
