import 'package:flutter/material.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/view_model/login_regist_vm.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/11 2:46 下午
/// @Description:注册
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const String _TAG = "RegisterPage ";

  late BaseViewModel _viewModel;

  late TextEditingController _phoneController = TextEditingController();

  late TextEditingController _passwordController = TextEditingController();

  late TextEditingController _rePasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "注册",
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
                  TextField(
                    controller: _passwordController,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 14, color: Colors.blue),
                    decoration: const InputDecoration(hintText: "请再次输入密码"),
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
                        _doRegister();
                      },
                      child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: const Text(
                            "注 册",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ))),
                ],
              ),
            ),
          ));
        },
      ),
    );
  }

  void _doRegister() {}
}
