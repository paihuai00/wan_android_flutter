import 'package:dio/dio.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/dios/requests/base_dio_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/11 1:35 下午
/// @Description:

class LoginRequest extends BaseDioRequest {
  //https://www.wanandroid.com/user/login?username=17610176618&password=123456 需登录
  Future<BaseDioResponse> doLogin(String username, String password,
      {CancelToken? cancelToken}) async {
    Map<String, dynamic> map = {};
    map["username"] = username;
    map["password"] = password;

    BaseDioResponse result = await httpClient.post("user/login",
        queryParameters: map, cancelToken: cancelToken);
    return result;
  }

  //https://www.wanandroid.com/lg/coin/userinfo/json 积分获取，需登录
  Future<BaseDioResponse> getCoinData({CancelToken? cancelToken}) async {
    BaseDioResponse result =
        await httpClient.get("lg/coin/userinfo/json", cancelToken: cancelToken);
    return result;
  }

  //https://www.wanandroid.com/user/register?username&password&repassword 注册
  Future<BaseDioResponse> doRegister(
      String username, String password, String repassword,
      {CancelToken? cancelToken}) async {
    Map<String, dynamic> map = {};
    map["username"] = username;
    map["password"] = password;
    map["repassword"] = repassword;

    BaseDioResponse result = await httpClient.post("user/register",
        queryParameters: map, cancelToken: cancelToken);
    return result;
  }
}
