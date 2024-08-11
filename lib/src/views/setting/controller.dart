import 'package:famd/src/common/color.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/models/setting_conf.dart';
import 'package:famd/src/utils/permission_util.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final _themeCtrl = Get.find<ThemeController>();
  Rx<SettingConf> settingConf = SettingConf().obs;
  RxBool isDarkMode = false.obs;

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
    isDarkMode.value = settingConf.value.darkMode.value == '1';
    update();
  }

  selectedDirectory() async {
    // requestPermission();
    if (GetPlatform.isAndroid) {
      bool isGranted = await checkStoragePermission();
      if (!isGranted) {
        EasyLoading.showToast(FamdLocale.noPermission.tr);
        return;
      }
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      // print(selectedDirectory);
      setConf(settingConf.value.downPath.name, selectedDirectory);
      settingConf.update((val) {
        settingConf.value.downPath.value = selectedDirectory;
      });
    }
  }

  changeThemeColor(FamdThemeColor themeColor) {
    settingConf.update((val) {
      settingConf.value.themeColor.value = themeColor.label;
    });
    setConf(settingConf.value.themeColor.name, themeColor.label);
    settingConf.value.themeColor.value = themeColor.label;
    _themeCtrl.updateMainColor(themeColor.color);
  }

  changeDarkMode(bool darkMode) {
    isDarkMode.update((val) {
      isDarkMode.value = darkMode;
    });
    settingConf.update((val) {
      settingConf.value.darkMode.value = darkMode ? '1' : '0';
    });
    setConf(settingConf.value.darkMode.name, darkMode ? '1' : '0');
    _themeCtrl.updateDarkMode(darkMode);
  }
}
