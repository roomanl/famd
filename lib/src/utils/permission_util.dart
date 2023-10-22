import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkStoragePermission() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on ${androidInfo.version.sdkInt}');
  print(androidInfo.version.sdkInt >= 30);
  if (androidInfo.version.sdkInt >= 30) {
    PermissionStatus manageStorageStatus =
        await Permission.manageExternalStorage.status;
    if (manageStorageStatus.isDenied) {
      return true;
    }
    if ((await Permission.manageExternalStorage.request()).isGranted) {
      return true;
    }
  } else {
    PermissionStatus storageStatus = await Permission.storage.status;
    if (storageStatus.isDenied) {
      return true;
    }
    if ((await Permission.storage.request()).isGranted) {
      return true;
    }
  }
  return false;
}
