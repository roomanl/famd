class FamdConfig {
  static const String aria2RpcUrl = 'http://127.0.0.1:{port}/jsonrpc';
  static const String famdGithub = 'https://github.com/roomanl/famd';
  static const String homePage = 'https://rootvip.cn';
  static const String appCheckVersionUrl =
      'https://oss.rootvip.cn/famd/app/version.json';
  //资源搜索API为maccms10 API，可自己搭建maccms10影视采集网站，然后替换下面的域名
  static const String m3u8WdSearchApi =
      'https://xxxx.cn/api.php/provide/vod/?ac=list&wd=';
  static const String m3u8DetailSearchApi =
      'https://xxxx.cn/api.php/provide/vod/?ac=detail&ids=';
}
