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

  static TextStyle getBlue18TextStyle() {
    return const TextStyle(fontSize: 18, color: Colors.blue);
  }

  static TextStyle getGrey18TextStyle() {
    return const TextStyle(fontSize: 18, color: Colors.grey);
  }

  static TextStyle getGrey14TextStyle() {
    return const TextStyle(fontSize: 14, color: Colors.grey);
  }

  static TextStyle getBlue14TextStyle() {
    return const TextStyle(fontSize: 14, color: Colors.blue);
  }

  static TextStyle getWhite16TextStyle() {
    return const TextStyle(fontSize: 16, color: Colors.white);
  }

  static TextStyle getBlack16TextStyle() {
    return const TextStyle(fontSize: 16, color: Colors.black);
  }

  static TextStyle getBlack18TextStyle() {
    return const TextStyle(fontSize: 18, color: Colors.black);
  }

  static TextStyle getWhite24TextStyle() {
    return const TextStyle(fontSize: 24, color: Colors.white);
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
