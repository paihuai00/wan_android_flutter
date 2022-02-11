import 'package:flutter/material.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/view_model/login_regist_vm.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/11 2:46 下午
/// @Description:登录
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const String _TAG = "LoginPage ";

  late BaseViewModel _viewModel;

  late TextEditingController _phoneController = TextEditingController();

  late TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();
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
  void _doLogin() {}

  void _doRegister() {
    NavigatorUtil.jump(context, RouterConfig.registerPage);
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
