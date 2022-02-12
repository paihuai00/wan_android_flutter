import 'package:flutter/material.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/dios/http_client.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/view_model/launch_vm.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:57 下午
/// @Description:

class LaunchPages extends StatefulWidget {
  LaunchPages({Key? key}) : super(key: key);

  @override
  _LaunchPagesState createState() => _LaunchPagesState();
}

class _LaunchPagesState extends State<LaunchPages> {
  @override
  void initState() {
    super.initState();

    //提前初始化 dio
    HttpDioClient dioClient = HttpDioClient();
    dioClient.initDioClient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BaseView<LaunchViewModel>(builder: (_) {
        return Container();
      }, onReady: (_, State state) async {
        //提前初始化
        // await SpUtil.getInstance().init();

        NavigatorUtil.jump(RouterConfig.homePage);
      }),
    );
  }
}
