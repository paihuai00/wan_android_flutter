import 'package:dio/dio.dart';
import 'package:wan_android_flutter/dios/http_response.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:38 下午
/// @Description:
/// Response 解析

abstract class HttpDioTransformer {
  BaseDioResponse parse(Response response);
}
