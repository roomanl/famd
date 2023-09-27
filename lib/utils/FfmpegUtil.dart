import 'dart:io';

import 'package:aria2_m3u8/utils/ASEUtil.dart';

import '../common/const.dart';
import 'ConfUtil.dart';

typedef Callback = void Function();
tsMergeTs(dtslistpath, mp4path, Callback callback) async {
  File file = File(mp4path);
  if (file.existsSync()) {
    file.deleteSync();
  }
  String? ffmpegPath = await getFFmpegPathConf();
  final exe = '$ffmpegPath/$FFMPGE_EXE_NAME';
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
