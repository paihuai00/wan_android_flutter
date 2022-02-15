import 'package:connectivity/connectivity.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/14 10:48
/// @Description:
class NetWorkUtils {
  ///判断网络是否可用
  ///0 - none | 1 - mobile | 2 - WIFI
  static Future<int> netWorkType() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      return 1;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return 2;
    } else {
      return 0;
    }
  }

  ///判断网络是否可用
  static Future<bool> isNetWorkAvailable() async {
    int type = await netWorkType();

    return type != 0;
  }
}
