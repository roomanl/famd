import 'package:famd/src/common/color.dart';
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
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: AppTileWidget(),
                ),
              ),
              const Expanded(
                child: StartBtnWidget(),
              ),
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Spacer(flex: 1),
                      const Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AppVersion(),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            color: FamdColor.white,
                            icon: const Icon(Icons.tune_rounded),
                            onPressed: () => controller.openSettingPage(),
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
