import 'package:famd/src/models/setting_conf.dart';
import 'package:famd/src/utils/permission_util.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  Rx<SettingConf> settingConf = SettingConf().obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _init();
  }

  _init() async {
    await settingConf.value.initValue();
    update();
  }

  selectedDirectory() async {
    // requestPermission();
    if (GetPlatform.isAndroid) {
      bool isGranted = await checkStoragePermission();
      if (!isGranted) {
        EasyLoading.showToast('没有权限');
        return;
      }
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      // print(selectedDirectory);
      setConf(settingConf.value.downPath.name, selectedDirectory);
      settingConf.value.downPath.value = selectedDirectory;
      update();
    }
  }
}
