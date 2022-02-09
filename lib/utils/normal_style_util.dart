import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/9 4:39 下午
/// @Description:

class NormalStyle {
  static TextStyle getTitleTextStyle() {
    return const TextStyle(fontSize: 20, color: Colors.black);
  }

  static TextStyle getSubTitleTextStyle() {
    return const TextStyle(fontSize: 16, color: Colors.grey);
  }

  static TextStyle getTimeTextStyle() {
    return const TextStyle(fontSize: 12, color: Colors.grey);
  }

  static Image getLikeImage(bool isLike) {
    return isLike
        ? Image.asset(
            "assets/images/ic_like.png",
            width: 20,
            height: 20,
          )
        : Image.asset("assets/images/ic_un_like.png", width: 20, height: 20);
  }
}
