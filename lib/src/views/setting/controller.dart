import 'package:famd/src/common/color.dart';
import 'package:famd/src/controller/theme.dart';
import 'package:famd/src/locale/locale.dart';
import 'package:famd/src/models/setting_conf.dart';
import 'package:famd/src/utils/permission_util.dart';
import 'package:famd/src/utils/setting_conf_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final _themeCtrl = Get.find<ThemeController>();
  Rx<SettingConf> settingConf = SettingConf().obs;
  RxBool isDarkMode = false.obs;
  final TextEditingController aria2PortTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _init();
    aria2PortTextController.addListener(() {
      setConf(settingConf.value.aria2Port.name, aria2PortTextController.text);
    });
  }

  _init() async {
    await settingConf.value.initValue();
    isDarkMode.value = settingConf.value.darkMode.value == '1';
    String aria2Port = settingConf.value.aria2Port.value;
    aria2PortTextController.text = aria2Port;
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

  changeRetryInterval(int num) {
    int interval = int.parse(settingConf.value.retryInterval.value) + num;
    interval = _checkMaxMiniValue(interval, 90, 15);
    settingConf.update((val) {
      settingConf.value.retryInterval.value = interval.toString();
      setConf(settingConf.value.retryInterval.name, interval.toString());
    });
  }

  changeMaxDownTsNum(int num) {
    int maxNum = int.parse(settingConf.value.maxDownTsNum.value) + num;
    maxNum = _checkMaxMiniValue(maxNum, 64, 8);
    settingConf.update((val) {
      settingConf.value.maxDownTsNum.value = maxNum.toString();
      setConf(settingConf.value.maxDownTsNum.name, maxNum.toString());
    });
  }

  changeMaxDownThread(int num) {
    int maxNum = int.parse(settingConf.value.maxDownThread.value) + num;
    maxNum = _checkMaxMiniValue(maxNum, 16, 4);
    settingConf.update((val) {
      settingConf.value.maxDownThread.value = maxNum.toString();
      setConf(settingConf.value.maxDownThread.name, maxNum.toString());
    });
  }

  int _checkMaxMiniValue(int val, int max, int mini) {
    if (val < mini) {
      val = mini;
      EasyLoading.showToast(FamdLocale.isMinimize.tr);
    } else if (val > max) {
      val = max;
      EasyLoading.showToast(FamdLocale.isMaximize.tr);
    }
    return val;
  }
}
