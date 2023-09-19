import 'dart:io';

import 'package:aria2_m3u8/utils/ASEUtil.dart';

import '../DB/server/SysConfigServer.dart';
import '../common/const.dart';

typedef Callback = void Function();
tsMergeTs(dtslistpath, mp4path, Callback callback) async {
  File file = File(mp4path);
  if (file.existsSync()) {
    file.deleteSync();
  }
  String? ffmpegPath = await findSysConfigByName(FFMPEG_PATH);
  final exe = '$ffmpegPath/bin/$FFMPGE_EXE_NAME';
  List<String> args = [
    '/c',
    exe,
    '-f',
    'concat',
    '-safe',
    '0',
    '-i',
    dtslistpath,
    '-c',
    'copy',
    mp4path
  ];
  var process = Process.runSync('cmd', args);
  String output = process.stdout;
  logger.i(output);
  Process.runSync('taskkill', ['/F', '/T', '/PID', '${process.pid}']);

  callback.call();
}
