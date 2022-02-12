import 'package:dio/dio.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/dios/requests/base_dio_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/12 2:16 下午
/// @Description: 收藏 & 取消收藏

class CollectionRequest extends BaseDioRequest {
  //https://www.wanandroid.com/lg/collect/1165/json
  Future<BaseDioResponse> doCollection(String id,
      {CancelToken? cancelToken}) async {
    BaseDioResponse result =
        await httpClient.post("lg/collect/$id/json", cancelToken: cancelToken);
    return result;
  }

  //https://www.wanandroid.com/lg/uncollect_originId/2333/json
  //取消收藏
  Future<BaseDioResponse> unCollection(String id,
      {CancelToken? cancelToken}) async {
    BaseDioResponse result = await httpClient
        .post("lg/uncollect_originId/$id/json", cancelToken: cancelToken);
    return result;
  }
}
