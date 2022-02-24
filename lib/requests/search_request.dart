import 'package:dio/dio.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/dios/requests/base_dio_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/22 4:52 下午
/// @Description:搜索 请求
class SearchRequest extends BaseDioRequest {
  //https://www.wanandroid.com/article/query/0/json?k=gradle
  Future<BaseDioResponse> getSearchList(int pageIndex, String keyWord,
      {CancelToken? cancelToken}) async {
    Map<String, dynamic> map = {};
    map["k"] = keyWord;
    map["page_size"] = 10;

    BaseDioResponse result = await httpClient.post(
        "article/query/$pageIndex/json",
        queryParameters: map,
        cancelToken: cancelToken);
    return result;
  }
}
