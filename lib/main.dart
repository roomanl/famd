import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import './pages/start_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(500, 650),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: const StartPage(),
    builder: EasyLoading.init(),
  ));
}
