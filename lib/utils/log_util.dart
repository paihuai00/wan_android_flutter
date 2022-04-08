import 'package:logger/logger.dart';
import 'package:wan_android_flutter/base/global_config.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/3 4:54 下午
/// @Description:

class XLog {
  static const String _TAG = "wan_android_project -->";

  static final _isPrint = GlobalConfig.isDebug;

  static final _logger = Logger(
      printer: PrettyPrinter(
          methodCount: 1,
          // number of method calls to be displayed
          errorMethodCount: 10,
          // number of method calls if stacktrace is provided
          lineLength: 10,
          // width of the output
          colors: true,
          // Colorful log messages
          printEmojis: false,
          // Print an emoji for each log message
          printTime: true // Should each log print contain a timestamp
          ));

  static void d({String? tag, required String message}) {
    if (!_isPrint) {
      return;
    }

    _logger.d("$_TAG  $tag -> ${message.toString()}");
  }

  static void e(
      {String? tag,
      required String message,
      dynamic error,
      StackTrace? stackTrace}) {
    if (!_isPrint) {
      return;
    }
    String tagMsg =
        tag == null ? "LoggerUtils -> $_TAG " : tag.toString() + "$_TAG :  ";

    _logger.e(tagMsg, error, stackTrace);
  }
}
