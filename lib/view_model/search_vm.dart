import 'package:dio/dio.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/requests/search_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/11 2:48 下午
/// @Description: 搜索 vm

class SearchViewModel extends BaseViewModel {
  late SearchRequest request = SearchRequest();

  @override
  void dispose() {
    super.dispose();
  }

  /// 列表数据请求
  Future<BaseDioResponse> getSearchData(int pageIndex, String ketWord,
      {CancelToken? cancelToken}) async {
    BaseDioResponse baseDioResponse = await request
        .getSearchList(pageIndex, ketWord, cancelToken: cancelToken);
    return baseDioResponse;
  }
}
