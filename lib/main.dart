import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/dios/http_client.dart';

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
    runApp(MyApp());

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
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home: Container(
      //   color: Colors.white,
      //   child: Center(
      //     child: Text(
      //       "data",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      // ),
      initialRoute: RouterConfig.launchPagePath,
      getPages: RouterConfig.getPages,
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
