import 'package:dio/dio.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/dios/requests/base_dio_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/5 3:41 下午
/// @Description:

class SystemRequest extends BaseDioRequest {
  //https://www.wanandroid.com/article/list/0/json?cid=60
  Future<BaseDioResponse> getDetailList(int pageIndex, String cid,
      {CancelToken? cancelToken}) async {
    BaseDioResponse result = await httpClient
        .get("article/list/$pageIndex/json?cid=$cid", cancelToken: cancelToken);
    return result;
  }
}
