import 'package:dio/dio.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/requests/collection_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/16 3:52 下午
/// @Description:

class CollectionLinkViewModel extends BaseViewModel {
  late CollectionRequest request = CollectionRequest();

  /// 列表数据请求
  Future<BaseDioResponse> getCollectionData(int pageIndex, int type,
      {CancelToken? cancelToken}) async {
    if (type == 1) {
      return await request.getCollectionList(pageIndex, type,
          cancelToken: cancelToken);
    }

    BaseDioResponse baseDioResponse = await request
        .getCollectionList(pageIndex, type, cancelToken: cancelToken);

    return baseDioResponse;
  }
}
