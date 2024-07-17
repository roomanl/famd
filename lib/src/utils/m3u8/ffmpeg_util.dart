import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import '../common_utils.dart';
import '../file_utils.dart';
import 'package:logger/logger.dart';

var logger = Logger();

tsMergeTs(dtslistpath, mp4path) async {
  logger.i(dtslistpath);
  logger.i(mp4path);
  File file = File(mp4path);
  if (file.existsSync()) {
    file.deleteSync();
  }
  List<String> args = [
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
  if (Platform.isWindows || Platform.isLinux) {
    String ffmpegPath = await getFFmpegExePath();
    if (Platform.isLinux) {
      permission777(ffmpegPath);
    }

    var process = await Process.run(ffmpegPath, args);
    String output = process.stdout;
    // Process.runSync('taskkill', ['/F', '/T', '/PID', '${process.pid}']);
    Process.killPid(process.pid);
    if (process.exitCode == 0) {
      return true;
    }
  } else if (Platform.isAndroid) {
    final session = await FFmpegKit.execute(args.join(' '));
    final returnCode = await session.getReturnCode();
    logger.i(returnCode);
    final failStackTrace = await session.getFailStackTrace();
    logger.i(failStackTrace);
    final output = await session.getOutput();
    logger.i(output);
    if (ReturnCode.isSuccess(returnCode)) {
      return true;
    }
  }
  return false;
}

getFFmpegExePath() async {
  String dir = await getPlugAssetsDir('ffmpeg');
  String ffmpegName = 'ffmpeg';
  if (Platform.isWindows) {
    ffmpegName = 'ffmpeg.exe';
  }
  return '$dir/$ffmpegName';
}
