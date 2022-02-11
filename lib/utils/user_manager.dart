import 'dart:convert';

import 'package:wan_android_flutter/models/user_model.dart';
import 'package:wan_android_flutter/utils/sp_utils.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/11 9:40 上午
/// @Description:
class UserManager {
  static UserManager? _instance;

  // 私有的命名构造函数
  UserManager._internal();

  static UserManager getInstance() {
    _instance ??= UserManager._internal();
    return _instance!;
  }

  bool isLogin() {
    return false;
  }

  ///用户信息
  UserData? getUser() {
    String loginJson = SpUtil.getInstance().getString(SpUtil.keyLogin);
    if (loginJson.isEmpty) {
      return null;
    }

    return UserModel.fromJson(jsonDecode(loginJson)).data;
  }
}
