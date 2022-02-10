import 'package:dio/dio.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/dios/requests/base_dio_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/10 11:21 上午
/// @Description: 广场

class SquareRequest extends BaseDioRequest {
  //https://www.wanandroid.com/navi/json 导航
  Future getNaviData({CancelToken? cancelToken}) async {
    BaseDioResponse result =
        await httpClient.get("navi/json", cancelToken: cancelToken);
    return result;
  }

  //https://www.wanandroid.com/tree/json 体系
  Future getSystemData({CancelToken? cancelToken}) async {
    BaseDioResponse result =
        await httpClient.get("tree/json", cancelToken: cancelToken);
    return result;
  }
}
