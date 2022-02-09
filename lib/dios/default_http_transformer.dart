import 'package:dio/dio.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/dios/http_transformer.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:35 下午
/// @Description:

class DefaultHttpTransformer extends HttpDioTransformer {
  @override
  BaseDioResponse parse(Response response) {
    if (response.data["status"] == 100) {
      return BaseDioResponse.success(response.data);
    } else if (response.data["errorCode"] == 0 &&
        response.data["errorMsg"] == "") {
      return BaseDioResponse.success(response.data);
    } else {
      return BaseDioResponse.failure(
          errorMsg: response.data["message"], errorCode: response.data["code"]);
    }
  }

  /// 单例对象
  static DefaultHttpTransformer _instance = DefaultHttpTransformer._internal();

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  DefaultHttpTransformer._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory DefaultHttpTransformer.getInstance() => _instance;
}
