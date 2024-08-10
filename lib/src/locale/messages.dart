import 'package:famd/src/locale/locale.dart';
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "zh_CN": {
          FamdLocale.authorName: "怡和路恶霸",
          FamdLocale.appName: "Famd M3u8下载器",
          FamdLocale.channelName: "免费版",
          FamdLocale.ariaStarting: "Aria2启动中...",
          FamdLocale.ariaStartFail: "启动失败!",
          FamdLocale.notNet: "未连接网络",
          FamdLocale.errorNet: "网络连接异常",
          FamdLocale.about: "关于",
          FamdLocale.version: "版本",
          FamdLocale.checkUpdate: "检查更新",
          FamdLocale.author: '作者',
          FamdLocale.ariaName: 'Aria2',
          FamdLocale.gitUrl: '开源地址',
          FamdLocale.homePage: '主页',
        },
        "en_US": {
          FamdLocale.appName: "Famd M3u8 Downloader",
          FamdLocale.channelName: "Free",
        },
      };
}
