import 'package:intl/intl.dart';

now({format = 'yyyy-MM-dd HH:mm:ss'}) {
  DateTime nowTime = DateTime.now();
  final formatter = DateFormat(format);
  return formatter.format(nowTime);
}
