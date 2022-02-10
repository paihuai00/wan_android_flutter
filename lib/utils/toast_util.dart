import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/5 6:37 下午
/// @Description:

class XToast {
  static void show(dynamic msg, {String tag = "XToast -> "}) {
    Fluttertoast.showToast(
        msg: msg.toString(), toastLength: Toast.LENGTH_SHORT);
  }

  static void showErrorToast(dynamic msg, {String tag = "XToast -> "}) {
    Fluttertoast.showToast(
        msg: msg.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER);
  }

  static void showRequestError({String msg = "请求错误，请重试"}) {
    show(msg);
  }
}
