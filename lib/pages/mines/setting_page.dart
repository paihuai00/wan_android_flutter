import 'package:flutter/material.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/requests/login_request.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/utils/event_bus.dart';
import 'package:wan_android_flutter/utils/event_bus_const_key.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/utils/user_manager.dart';
import 'package:wan_android_flutter/view_model/login_regist_vm.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/11 2:46 下午
/// @Description:设置
class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends BaseState<SettingPage> {
  static const String _TAG = "SettingPage ";

  late BaseViewModel _viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (!_viewModel.cancelToken.isCancelled) {
      _viewModel.cancelToken.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "设置",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: BaseView<LoginRegisterViewModel>(
        builder: (vm) {
          _viewModel = vm;
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  _buildNormalWidget("清除缓存", ""),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildNormalWidget("版本", "1.0.0"),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildNormalWidget("作者", "csx"),
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
                        _loginOut();
                      },
                      child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: const Text(
                            "退出登录",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //登录
  void _loginOut() async {
    _viewModel.startLoading(this);

    BaseDioResponse loginOutResponse =
        await LoginRequest().loginOut(cancelToken: _viewModel.cancelToken);

    if (loginOutResponse.ok) {
      //退出登录
      UserManager.getInstance().loginOut();

      //通知其他页面更新
      eventBus.sendBroadcast(EventBusKey.loginOut);

      XToast.show("登录成功");
    } else {
      XToast.showRequestError();
    }

    _viewModel.stopLoading(this);

    if (loginOutResponse.ok) {
      NavigatorUtil.goBack(context);
    }
  }

  void _doRegister() {
    NavigatorUtil.jump(RouterConfig.registerPage);
  }

  Widget _buildNormalWidget(String title, String rightStr) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.black38),
            ),
            const Expanded(child: SizedBox()),
            rightStr.isEmpty
                ? const SizedBox()
                : Text(
                    rightStr,
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
          ],
        ),
      ),
    );
  }
}
