import 'package:dio/dio.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:36 下午
/// @Description:

class HttpDioConfig {
  final String? baseUrl;
  final String? proxy;
  final String? cookiesPath;
  final List<Interceptor>? interceptors;
  final int connectTimeout;
  final int sendTimeout;
  final int receiveTimeout;
  final Map<String, dynamic>? headers;

  HttpDioConfig({
    this.baseUrl,
    this.headers,
    this.proxy,
    this.cookiesPath,
    this.interceptors,
    this.connectTimeout = Duration.millisecondsPerMinute,
    this.sendTimeout = Duration.millisecondsPerMinute,
    this.receiveTimeout = Duration.millisecondsPerMinute,
  });

// static DioConfig of() => Get.find<DioConfig>();
}
