import 'dart:io';
import 'FileUtils.dart';

tsMergeTs(dtslistpath, mp4path) async {
  File file = File(mp4path);
  if (file.existsSync()) {
    file.deleteSync();
  }
  String ffmpegPath = getFFmpegExePath();
  List<String> args = [
    '/c',
    ffmpegPath,
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
  Process.runSync('taskkill', ['/F', '/T', '/PID', '${process.pid}']);
  if (process.exitCode == 0) {
    return true;
  }
  return false;
}

getFFmpegExePath() {
  String dir = getPlugAssetsDir('ffmpeg');
  return '$dir/ffmpeg.exe';
}
