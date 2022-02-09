import 'dart:io';

import 'package:dio/dio.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:39 下午
/// @Description:  Response 解析

abstract class HttpTransformer {
  HttpResponse parse(Response response);
}
