import 'package:wan_android_flutter/dios/http_exceptions.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:38 下午
/// @Description:  响应基类

class BaseDioResponse<T> {
  late bool ok;
  T? data;
  HttpDioException? error;

  BaseDioResponse._internal({this.ok = false});

  BaseDioResponse.success(this.data) {
    ok = true;
  }

  BaseDioResponse.failure({String? errorMsg, int? errorCode}) {
    error = BadRequestException(message: errorMsg, code: errorCode);
    ok = false;
  }

  BaseDioResponse.failureFormResponse({dynamic? data}) {
    error = BadResponseException(data);
    this.ok = false;
  }

  BaseDioResponse.failureFromError([HttpDioException? error]) {
    this.error = error ?? UnknownException();
    this.ok = false;
  }
}
