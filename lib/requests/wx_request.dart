import 'package:dio/dio.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/dios/requests/base_dio_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/10 4:58 下午
/// @Description: 公众号

class WxRequest extends BaseDioRequest {
  //https://wanandroid.com/wxarticle/chapters/json  公众号 tab
  Future getWxTabData({CancelToken? cancelToken}) async {
    BaseDioResponse result = await httpClient.get("wxarticle/chapters/json",
        cancelToken: cancelToken);
    return result;
  }

  //https://wanandroid.com/wxarticle/list/408/1/json
  Future getWxDetailData(String id, int pageIndex,
      {CancelToken? cancelToken}) async {
    BaseDioResponse result = await httpClient
        .get("wxarticle/list/$id/$pageIndex/json ", cancelToken: cancelToken);
    return result;
  }
}
