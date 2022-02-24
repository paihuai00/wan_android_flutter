import 'package:date_format/date_format.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/24 1:38 下午
/// @Description:
class TimeUtil {
  //2022-02-24
  static final normalYMD = ['yyyy', '-', 'mm', '-', 'dd'];

  //2022-02-24 09:20:17
  static final normalYMDHNS = [
    'yyyy',
    '-',
    'mm',
    '-',
    'dd',
    ' ',
    'HH',
    ':',
    'nn',
    ':',
    'ss'
  ];

  static String getTime(int time, {List<String>? formats}) {
    return formatDate(
        DateTime.fromMillisecondsSinceEpoch(time), formats ?? normalYMDHNS);
  }
}
