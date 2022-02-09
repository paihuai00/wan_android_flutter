import 'package:dio/dio.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/dios/requests/base_dio_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/5 3:41 下午
/// @Description:

class ProjectRequest extends BaseDioRequest {
  //https://www.wanandroid.com/project/tree/json
  Future<BaseDioResponse> getProjectTabList({CancelToken? cancelToken}) async {
    BaseDioResponse result =
        await httpClient.get("project/tree/json", cancelToken: cancelToken);
    return result;
  }

  //https://www.wanandroid.com/project/list/1/json?cid=294
  Future<BaseDioResponse> getDetailList(int pageIndex, String cid,
      {CancelToken? cancelToken}) async {
    BaseDioResponse result = await httpClient
        .get("project/list/$pageIndex/json?cid=$cid", cancelToken: cancelToken);
    return result;
  }
}
