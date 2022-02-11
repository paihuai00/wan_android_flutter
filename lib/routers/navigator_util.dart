import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/utils/event_bus.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:59 下午
/// @Description:

class NavigatorUtil {
  late Route? currentRoute;
  factory NavigatorUtil() {
    _singleton ??= NavigatorUtil._();
    return _singleton!;
  }

  NavigatorUtil._() {
    bus.addListener("didPush_route", (arg) {
      this.currentRoute = arg;
    });
  }

  static NavigatorUtil? _singleton;
  // 返回

  static void goBack(BuildContext context) {
    /// 其实这边调用的是
    // Navigator.pop(context);
    if (Navigator.canPop(context)) {
      Get.back();
    }
  }

  // 跳转到主页面
  static void goHomePage(BuildContext context) {
    //反复返回，直到表达式返回真
    Get.until((route) => Get.currentRoute == RouterConfig.homePage);
  }

  /// 跳转到 转场动画 页面 ， 这边只展示 inFromLeft ，剩下的自己去尝试下，
  /// 框架自带的有 native，nativeModal，inFromLeft，inFromRight，inFromBottom，fadeIn，custom
  static Future? jump(BuildContext? context, String title,
      {Object? arguments}) {
    // RouteSettings settings = RouteSettings(name: "params", arguments: arguments);
    return Get.toNamed(title, arguments: arguments, preventDuplicates: false);

    /// 指定了 转场动画
  }

  /// 框架自带的有 native，nativeModal，inFromLeft，inFromRight，inFromBottom，fadeIn，custom
// static Future jumpWithType(BuildContext context, String title, Transition type,{Object? arguments}) {
//   RouteSettings settings = RouteSettings(name: "params", arguments: arguments);
//   return Get.toNamed(title,);        /// 指定了 转场动画
// }
// static Future jumpRemove(BuildContext context) {        return Navigator.of(context).pushAndRemoveUntil(            MaterialPageRoute(                builder: (context) => IndexPage(),            ),
//         (route) => route == null);    }

  /// 自定义 转场动画
// Future goScaleTransitionPage(BuildContext context, String title) {
//   var transition = (BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     if (this.currentRoute != null && !currentRoute!.isActive){
//       return Container(width: 0,height: 0,);
//     }
//     // logger.d("isActive " + currentRoute!.isActive.toString());
//     print("isActive");
//     return Stack(
//       children: [
//         ScaleTransition(
//           scale: Tween(
//               begin: 0.0,
//               end: 1.0
//           ).animate(
//             CurvedAnimation(
//               parent: animation,
//               curve: Interval(0.0, 0.5),
//             ),
//           ),
//           child: Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: Color(0xeeffffff),
//           ),
//         ),
//         FadeTransition(
//           opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
//             CurvedAnimation(
//               parent: animation,
//               curve: Interval(0.5, 1),
//             ),
//           ),
//           child: ScaleTransition(
//             scale: Tween<double>(
//               begin: 0.2,
//               end: 1,
//             ).animate(
//               CurvedAnimation(
//                 parent: animation,
//                 curve: Interval(0.5, 1.0, curve: Curves.linear),
//               ),
//             ),
//             child: child,
//           ),
//         ),
//       ],
//     );
//   };
//   return FluroRouter.appRouter.navigateTo(context, title,
//       transition: TransitionType.custom,
//       /// 指定是自定义动画
//       transitionBuilder: transition,
//       /// 自定义的动画
//       transitionDuration: const Duration(milliseconds: 600),);
//   /// 时间
// }

  /// 使用 IOS 的 Cupertino 的转场动画，这个是修改了源码的 转场动画
  /// Fluro本身不带，但是 Flutter自带
// static Future gotransitionCupertinoDemoPage(
//     BuildContext context, String title) {
//   return FluroRouter.appRouter.navigateTo(context, title, transition: TransitionType.cupertino);
// }

// 跳转到主页面IndexPage并删除当前路由
// static void goToHomeRemovePage(BuildContext context) {
//   Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(
//         builder: (context) => IndexPage(),
//       ), (route) => route == null);
// }
//
// // 跳转到登录页并删除当前路由
// static void goToLoginRemovePage(BuildContext context) {
//   Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(
//         builder: (context) => Login(),
//       ), (route) => route == null);
// }
}
