import 'dart:convert';

import 'package:wan_android_flutter/models/user_coin_model.dart';
import 'package:wan_android_flutter/models/user_model.dart';
import 'package:wan_android_flutter/utils/sp_utils.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/11 9:40 上午
/// @Description:
class UserManager {
  static UserManager? _instance;

  var _isLogin = false;
  UserData? _userData;
  UserCoinData? _userCoinData;

  // 私有的命名构造函数
  UserManager._internal();

  static UserManager getInstance() {
    _instance ??= UserManager._internal();
    return _instance!;
  }

  bool isLogin() {
    return _isLogin;
  }

  ///用户信息
  UserData? getUser() {
    if (_userData != null) {
      return _userData;
    }

    String loginJson = SpUtil.getInstance().getString(SpUtil.keyLogin);
    if (loginJson.isEmpty) {
      return null;
    }

    return UserModel.fromJson(jsonDecode(loginJson)).data;
  }

  void setUser(UserData userData) {
    _isLogin = true;
    _userData = userData;
  }

  //用户积分
  UserCoinData? getUserCoin() {
    if (_userCoinData != null) {
      return _userCoinData;
    }

    String loginJson = SpUtil.getInstance().getString(SpUtil.keyUserCoin);
    if (loginJson.isEmpty) {
      return null;
    }

    return UserCoinModel.fromJson(jsonDecode(loginJson)).data;
  }

  void setUserCoin(UserCoinData userCoinData) {
    _userCoinData = userCoinData;
  }
}
