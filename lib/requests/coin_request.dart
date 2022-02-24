import 'package:dio/dio.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/dios/requests/base_dio_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/24 10:34 上午
/// @Description:

class CoinRequest extends BaseDioRequest {
  // 需要登录 https://www.wanandroid.com//lg/coin/list/0/json
  Future<BaseDioResponse> getCoinListData(int pageIndex,
      {CancelToken? cancelToken}) async {
    BaseDioResponse result = await httpClient
        .get("lg/coin/list/$pageIndex/json", cancelToken: cancelToken);
    return result;
  }
}
