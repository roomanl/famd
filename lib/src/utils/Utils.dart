import 'dart:io';
import 'dart:math';

bytesToSize(bytes) {
  if (bytes == 0) return '0 B';
  var k = 1024;
  var sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  var i = (log(bytes) / log(k)).floor();
  return (bytes / pow(k, i)).toStringAsFixed(2) + ' ' + sizes[i];
}
