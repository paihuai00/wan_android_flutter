import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/dios/requests/base_dio_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/5 3:42 下午
/// @Description:

class HomeListRequest extends BaseDioRequest {
  //https://www.wanandroid.com/article/list/1/json
  Future<BaseDioResponse> getBannerList(int pageIndex) async {
    BaseDioResponse result =
        await httpClient.get("article/list/$pageIndex/json");
    return result;
  }
}
