import 'package:flutter/cupertino.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/10 4:21 下午
/// @Description:
class ScreenUtils {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  //顶部状态栏 高度
  static double getStateHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }
}
