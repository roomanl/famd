import 'package:famd/src/locale/locale.dart';
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "zh_CN": {
          FamdLocale.authorName: "怡和路恶霸",
          FamdLocale.appName: "Famd M3u8下载器",
          FamdLocale.channelName: "免费版",
          FamdLocale.appNameAs: "Famd",
          FamdLocale.ariaStarting: "Aria2启动中...",
          FamdLocale.ariaStartFail: "启动失败",
          FamdLocale.ariaStartSuccess: "启动成功",
          FamdLocale.notNet: "未连接网络",
          FamdLocale.errorNet: "网络连接异常",
          FamdLocale.about: "关于",
          FamdLocale.version: "版本",
          FamdLocale.checkUpdate: "检查更新",
          FamdLocale.checkingUpdate: "正在检查更新",
          FamdLocale.hasNewVersion: "有新版本",
          FamdLocale.currentVersion: "当前版本",
          FamdLocale.latestVersion: "最  新 版",
          FamdLocale.updateContent: "更新内容",
          FamdLocale.update: "更新",
          FamdLocale.hasUpdate: "有更新",
          FamdLocale.author: '作者',
          FamdLocale.ariaName: 'Aria2',
          FamdLocale.gitUrl: '开源地址',
          FamdLocale.homePage: '主页',
          FamdLocale.add: '添加',
          FamdLocale.addSuccess: '添加成功',
          FamdLocale.addTask: '添加任务',
          FamdLocale.taskManager: '任务管理',
          FamdLocale.addTaskInputUrlHint:
              '请输入视频链接，格式为：xxx\$http://abc.m3u8,多个链接时，请确保每行只有一个链接。(xxx可以是第01集、第12期、高清版、1080P等)',
          FamdLocale.addTaskInptNameHint: '请输入具体视频名称，例如：西游记',
          FamdLocale.addTaskInputUrlCantEmpty: 'URL或名称不能为空',
          FamdLocale.linkError: '链接格式不正确',
          FamdLocale.linkErrorTip: '不是有效的m3u8地址（只支持http或https的M3U8地址）',
          FamdLocale.alreadyInList: '已在列表中',
          FamdLocale.setting: '设置',
          FamdLocale.discussion: '讨论',
          FamdLocale.m3u8Resource: 'M3U8资源',
          FamdLocale.noPermission: '没有权限',
          FamdLocale.downDir: '下载目录',
          FamdLocale.change: '更改',
          FamdLocale.themeColor: '主题色',
          FamdLocale.selectThemeColor: '选择主题色',
          FamdLocale.darkMode: '暗黑模式',
          FamdLocale.darkModeThemeTip: '开启暗黑模式,主题色无效',
          FamdLocale.on: '开启',
          FamdLocale.off: '关闭',
          FamdLocale.serverError: '服务器错误',
          FamdLocale.urlInvalid: '地址失效',
          FamdLocale.addTaskList: '加入任务列表',
          FamdLocale.source: '资源',
          FamdLocale.search: '搜索',
          FamdLocale.searchIputHint: '请输入关键字进行搜索',
          FamdLocale.inSearch: '搜索中',
          FamdLocale.noSearchResult: '没有搜索到相关结果',
          FamdLocale.year: '年',
          FamdLocale.find: '探索',
          FamdLocale.startDown: '开始下载',
          FamdLocale.reStartDown: '重新下载',
          FamdLocale.reJoinDown: '任务已重新添加到下载中',
          FamdLocale.cleanTask: '清空任务',
          FamdLocale.waitDown: '等待下载',
          FamdLocale.downSuccess: '下载成功',
          FamdLocale.downFail: '下载失败',
          FamdLocale.deleTaskTip: '确定要删除此任务以及本地文件吗？',
          FamdLocale.deleAllTaskTip: '确定要删除所有任务以及本地文件吗？',
          FamdLocale.downSpeed: '下载速度',
          FamdLocale.tsNum: '分片总数',
          FamdLocale.decrtyStatus: '解密状态',
          FamdLocale.downProgress: '下载进度',
          FamdLocale.downTsNum: '已下载数',
          FamdLocale.mergeStatus: '合并状态',
          FamdLocale.downloading: '下载中',
          FamdLocale.downFinish: '下载完成',
          FamdLocale.confirm: '确定',
          FamdLocale.cancel: '取消',
          FamdLocale.tip: '提示',
          FamdLocale.alreadyDownloading: '已经在下载中',
          FamdLocale.listNoTask: '列表中没有任务',
          FamdLocale.startingTask: '正在开始任务...',
          FamdLocale.parseFail: '解析失败',
          FamdLocale.tryAgain: '重试',
          FamdLocale.decrypting: '解密中',
          FamdLocale.decrypFail: '解密失败',
          FamdLocale.decrypSuccess: '解密成功',
          FamdLocale.decrypFinish: '解密完成',
          FamdLocale.mergeing: '合并中',
          FamdLocale.mergeFinish: '合并完成',
          FamdLocale.mergeFail: '合并失败',
          FamdLocale.developing: '功能未实现',
          FamdLocale.retryInterval: '自动重试间隔',
          FamdLocale.retryIntervalTip: '秒没有新分片下载成功，自动重试（最少15秒）',
          FamdLocale.maxDownTsNum: '同时下载分片数',
          FamdLocale.maxDownTsNumTip: '注意：不是同时下载视频数，是下载一个视频时同时下载的分片数（重启后生效）',
          FamdLocale.maxDownThread: '下载线程数',
          FamdLocale.maxDownThreadTip: '最大16（重启后生效）',
          FamdLocale.isMaximize: '已达到最大值',
          FamdLocale.isMinimize: '已达到最小值',
          FamdLocale.isMaxVersion: '已经是最新版本',
          FamdLocale.more: '更多菜单',
          FamdLocale.colorJFZ: '剑锋紫',
          FamdLocale.colorJHZ: '芥花紫',
          FamdLocale.colorYH: '玉红',
          FamdLocale.colorSCH: '山茶红',
          FamdLocale.colorBSL: '宝石蓝',
          FamdLocale.colorKQL: '孔雀蓝',
          FamdLocale.colorTL: '铜绿',
          FamdLocale.colorKQLV: '孔雀绿',
          FamdLocale.colorYYH: '燕羽灰',
          FamdLocale.colorHTH: '河豚灰',
        },
        "en_US": {
          FamdLocale.appName: "Famd M3u8 Downloader",
          FamdLocale.channelName: "Free",
        },
      };
}
