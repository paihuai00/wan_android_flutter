import 'package:dio/dio.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/requests/coin_request.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/24 10:30 上午
/// @Description:

class CoinViewModel extends BaseViewModel {
  late CoinRequest request = CoinRequest();

  /// 列表数据请求
  Future<BaseDioResponse> getCoinListData(int pageIndex,
      {CancelToken? cancelToken}) async {
    return await request.getCoinListData(pageIndex, cancelToken: cancelToken);
  }
}
