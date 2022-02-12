import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/dios/http_client.dart';
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

    ///初始化 sp
    await SpUtil.getInstance().init();

    ///初始化dio
    HttpDioClient dioClient = HttpDioClient();
    dioClient.initDioClient();
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
      title: 'Flutter Demo',
      theme: ThemeData(
        // 主题色
        primarySwatch: Colors.blue,
      ),
      initialRoute: RouterConfig.launchPagePath,
      getPages: RouterConfig.getPages,
      defaultTransition: Transition.rightToLeftWithFade,
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
