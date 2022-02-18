import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/utils/sp_utils.dart';

import 'routers/router_config.dart';

var inProduction = false;

void main() {
  FlutterError.onError = (FlutterErrorDetails details) async {
    print("捕捉到错误" + details.stack.toString());
    if (!inProduction) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  runZonedGuarded<Future<Null>>(() async {
    WidgetsFlutterBinding.ensureInitialized(); //不加这个强制横/竖屏会报错
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    // SystemChrome.setPreferredOrientations([
    //   //强制横屏
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight
    // ]);

    runApp(MyApp());
    if (GetPlatform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
      SystemUiOverlayStyle systemUiOverlayStyle =
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    ///初始化 sp
    await SpUtil.getInstance().init();
  }, (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///Getx,配置
    var app = GetMaterialApp(
      theme: ThemeData(
        // 主题色
        brightness: Brightness.light, //控件颜色模式Light
        primaryColor: Colors.blue, //设置主题色为黑色即可
      ),
      initialRoute: RouterConfig.launchPagePath,
      getPages: RouterConfig.getPages,
      defaultTransition: Transition.rightToLeftWithFade,
      enableLog: true,
    );
    // return app;
    return ScreenUtilInit(
      builder: () => app,
      designSize: const Size(375, 812),
    );
  }
}

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  // if (!EnvUtil.inProduction) {
  //   print(stackTrace);
  //   return;
  // }
  //上报结果处理 //TODO TEST
}
