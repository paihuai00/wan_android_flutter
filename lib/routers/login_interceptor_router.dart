import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/utils/user_manager.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/16 10:33 上午
/// @Description: 登录 拦截器
///  1. 将需要判断登录的page，添加到这个needLoginPage  list中
///  2. 在 GetPage 中配置 GetMiddleware
///
class LoginInterceptorRouter extends GetMiddleware {
  final String _TAG = "LoginInterceptorRouter ";

  static const String nextPageKey = "next_page";

  /// 需要拦截的 page
  List<String> needLoginPage = [
    RouterConfig.settingPage,
    RouterConfig.mineCollectionPage
  ];

  @override
  RouteSettings? redirect(String? route) {
    if (route == null ||
        !needLoginPage.contains(route) ||
        UserManager.getInstance().isLogin()) {
      return null;
    }

    XLog.d(message: "需要登录拦截的路由为：$route", tag: _TAG);

    Future.delayed(const Duration(milliseconds: 500), () {
      XToast.showLoginError();
    });
    return RouteSettings(
        name: RouterConfig.loginPage, arguments: {nextPageKey: route});
  }
}
