import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/user_coin_model.dart';
import 'package:wan_android_flutter/models/user_model.dart';
import 'package:wan_android_flutter/requests/login_request.dart';
import 'package:wan_android_flutter/routers/login_interceptor_router.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/utils/event_bus.dart';
import 'package:wan_android_flutter/utils/event_bus_const_key.dart';
import 'package:wan_android_flutter/utils/sp_utils.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/utils/user_manager.dart';
import 'package:wan_android_flutter/view_model/login_regist_vm.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/11 2:46 下午
/// @Description:登录
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> {
  static const String _TAG = "LoginPage ";

  late BaseViewModel _viewModel;

  late final TextEditingController _phoneController = TextEditingController();

  late final TextEditingController _passwordController =
      TextEditingController();

  late final CancelToken _coinCancelToken = CancelToken();

  String nextPages = ""; //登录后，需跳转的路由

  @override
  void initState() {
    super.initState();

    if (Get.arguments != null && Get.arguments is Map) {
      nextPages = Get.arguments[LoginInterceptorRouter.nextPageKey];
    }

    _phoneController.text = "17610176618";
    _passwordController.text = "123456";
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();
    if (!_viewModel.cancelToken.isCancelled) {
      _viewModel.cancelToken.cancel();
    }
    if (!_coinCancelToken.isCancelled) {
      _coinCancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "登录",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: BaseView<LoginRegisterViewModel>(
        builder: (vm) {
          _viewModel = vm;
          return SafeArea(
              child: Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _phoneController,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 14, color: Colors.blue),
                    decoration: const InputDecoration(hintText: "请输入账号"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _passwordController,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 14, color: Colors.blue),
                    decoration: const InputDecoration(hintText: "请输入密码"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20)))), //圆角弧度
                      ),
                      onPressed: () {
                        _doLogin();
                      },
                      child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: const Text(
                            "登 录",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ))),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      InkWell(
                        onTap: () {
                          _doRegister();
                        },
                        child: const Text(
                          "注 册",
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  )
                ],
              ),
            ),
          ));
        },
      ),
    );
  }

  //登录
  void _doLogin() async {
    String username = _phoneController.text;
    String password = _passwordController.text;

    if (username.isEmpty) {
      XToast.show("请输入账号");
      return;
    }

    if (password.isEmpty) {
      XToast.show("请输入密码");
      return;
    }

    _viewModel.startLoading(this);

    BaseDioResponse loginResponse = await LoginRequest()
        .doLogin(username, password, cancelToken: _viewModel.cancelToken);

    BaseDioResponse userInfoResponse =
        await LoginRequest().getUserInfoData(cancelToken: _coinCancelToken);

    bool isLoginSuccess = loginResponse.ok && userInfoResponse.ok;

    if (isLoginSuccess) {
      //1，登录
      SpUtil.getInstance().set(SpUtil.keyLogin, jsonEncode(loginResponse.data));
      UserData userData = UserModel.fromJson(loginResponse.data).data!;
      UserManager.getInstance().setUser(userData);

      //2，积分
      SpUtil.getInstance()
          .set(SpUtil.keyUserCoin, jsonEncode(userInfoResponse.data));
      UserInfoData userCoinData =
          UserCoinModel.fromJson(userInfoResponse.data).data!;
      UserManager.getInstance().setUserInfo(userCoinData);

      //通知其他页面更新
      eventBus.sendBroadcast(EventBusKey.loginSuccess);

      XToast.show("登录成功");
    } else {
      XToast.showRequestError();
    }

    _viewModel.stopLoading(this);

    if (isLoginSuccess) {
      NavigatorUtil.goBack(context);

      if (nextPages.isNotEmpty) {
        NavigatorUtil.jump(nextPages);
      }
    }
  }

  void _doRegister() {
    NavigatorUtil.jump(RouterConfig.registerPage);
  }

// _buildTop() {
//   return Row(
//     children: <Widget>[
//       InkWell(
//         onTap: () {
//           NavigatorUtil.goBack(context);
//         },
//         child: const Icon(
//           Icons.close,
//           size: 30,
//           color: NormalColor.textBlue,
//         ),
//       ),
//       Expanded(
//           child: Container(
//         alignment: Alignment.center,
//         child: Text(
//           "登录",
//           style: TextStyle(fontSize: 28, color: Colors.blue),
//         ),
//       ))
//     ],
//   );
// }
}
