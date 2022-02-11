import 'package:shared_preferences/shared_preferences.dart';

import 'log_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/5 2:23 下午
/// @Description:  db 管理类
///
/// 注意，要先调用【    SpUtil.getInstance().init();  】

class SpUtil {
  final String _TAG = "SpUtil ";

  static const String keyLogin = "login_user";

  static late SharedPreferences _sharedPreferences;

  ///项目初始化的时候，需要先调用该方法
  Future<SharedPreferences> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences;
  }

  //私有化构造函数
  SpUtil._() {
    init();
  }

  static SpUtil? _instance;

  static SpUtil getInstance() {
    //??=，如果变量没有赋值才进行赋值，否则不进行赋值
    _instance ??= SpUtil._();
    return _instance!;
  }

  ///Set------
  void set(String key, Object value) {
    if (value is String) {
      _sharedPreferences.setString(key, value);
    } else if (value is int) {
      _sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      _sharedPreferences.setBool(key, value);
    } else if (value is double) {
      _sharedPreferences.setDouble(key, value);
    } else if (value is List<String>) {
      _sharedPreferences.setStringList(key, value);
    } else {
      XLog.e(
          tag: _TAG,
          message:
              "key = $key , value = $value , runtimeType =  ${value.runtimeType} 不支持类型");
    }
  }

  /// get ---------
  double getDouble(String key) {
    if (!containsKey(key)) {
      return -1;
    }
    return _sharedPreferences.getDouble(key)!;
  }

  String getString(String key) {
    if (!containsKey(key)) {
      return "";
    }
    return _sharedPreferences.getString(key)!;
  }

  int getInt(String key) {
    if (!containsKey(key)) {
      return -1;
    }
    return _sharedPreferences.getInt(key)!;
  }

  bool getBool(String key) {
    if (!containsKey(key)) {
      return false;
    }
    return _sharedPreferences.getBool(key)!;
  }

  List<String> getStringList(String key) {
    if (!containsKey(key)) {
      return [];
    }
    return _sharedPreferences.getStringList(key)!;
  }

  bool containsKey(String key) => _sharedPreferences.containsKey(key);

  bool remove(String key) {
    if (containsKey(key)) {
      _sharedPreferences.remove(key);
      return true;
    }

    return false;
  }
}
