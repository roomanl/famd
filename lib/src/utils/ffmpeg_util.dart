import 'dart:io';
import 'common_utils.dart';
import 'file_utils.dart';

tsMergeTs(dtslistpath, mp4path) async {
  File file = File(mp4path);
  if (file.existsSync()) {
    file.deleteSync();
  }
  String ffmpegPath = await getFFmpegExePath();
  if (Platform.isLinux) {
    permission777(ffmpegPath);
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
  var process = Process.runSync(ffmpegPath, args);
  String output = process.stdout;
  // Process.runSync('taskkill', ['/F', '/T', '/PID', '${process.pid}']);
  Process.killPid(process.pid);
  if (process.exitCode == 0) {
    return true;
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
