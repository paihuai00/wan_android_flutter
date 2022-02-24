import 'package:dio/dio.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/dios/requests/base_dio_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/5 3:41 下午
/// @Description:

class HomeRequest extends BaseDioRequest {
  //https://www.wanandroid.com/banner/json
  Future<BaseDioResponse> getBannerList({CancelToken? cancelToken}) async {
    BaseDioResponse result =
        await httpClient.get("banner/json", cancelToken: cancelToken);
    return result;
  }

  //https://www.wanandroid.com/article/list/1/json
  Future<BaseDioResponse> getHomeList(int pageIndex,
      {CancelToken? cancelToken}) async {
    BaseDioResponse result = await httpClient.get(
        "article/list/$pageIndex/json?pageSize=10",
        cancelToken: cancelToken);
    return result;
  }

  //https://www.wanandroid.com/article/top/json
  Future<BaseDioResponse> getTopArticles({CancelToken? cancelToken}) async {
    BaseDioResponse result =
        await httpClient.get("article/top/json", cancelToken: cancelToken);
    return result;
  }
}
