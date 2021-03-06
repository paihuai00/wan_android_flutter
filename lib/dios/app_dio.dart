import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:wan_android_flutter/base/global_config.dart';
import 'package:wan_android_flutter/dios/http_config.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:34 下午
/// @Description:

class AppDio with DioMixin implements Dio {
  CookieManager? _cookieManager;

  String _currentProxy = "";

  AppDio({BaseOptions? options, HttpDioConfig? dioConfig}) {
    options ??= BaseOptions(
      baseUrl: dioConfig?.baseUrl ?? "",
      contentType: 'application/json',
      connectTimeout: dioConfig?.connectTimeout,
      sendTimeout: dioConfig?.sendTimeout,
      receiveTimeout: dioConfig?.receiveTimeout,
    )..headers = dioConfig?.headers;
    this.options = options;

    // DioCacheManager
    final cacheOptions = CacheOptions(
      // A default store is required for interceptor.
      store: MemCacheStore(),
      // Optional. Returns a cached response on error but for statuses 401 & 403.
      hitCacheOnErrorExcept: [401, 403],
      // Optional. Overrides any HTTP directive to delete entry past this duration.
      maxStale: const Duration(days: 7),
    );
    interceptors.add(DioCacheInterceptor(options: cacheOptions));
    // Cookie管理
    if (dioConfig?.cookiesPath?.isNotEmpty ?? false) {
      _cookieManager = CookieManager(
          PersistCookieJar(storage: FileStorage(dioConfig!.cookiesPath)));
      interceptors.add(_cookieManager!);
    }

    if (GlobalConfig.isDebug) {
      interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: false,
          requestBody: true));
    }
    if (dioConfig?.interceptors?.isNotEmpty ?? false) {
      interceptors.addAll(dioConfig!.interceptors!);
    }
    httpClientAdapter = DefaultHttpClientAdapter();
    if (dioConfig?.proxy?.isNotEmpty ?? false) {
      setProxy(dioConfig!.proxy!);
    }
  }

  setProxy(String proxyIP, {String proxyPort = "8888"}) {
    _currentProxy = proxyIP;

    (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      //这一段是解决安卓https抓包的问题
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return Platform.isAndroid;
      };

      client.findProxy = (uri) {
        // proxy all request to localhost:8888
        return "PROXY " + proxyIP + ":" + proxyPort;
      };
      // you can also create a HttpClient to dio
      // return HttpClient();
    };
  }

  ///拿到当前的 代理ip
  getCurrentProxy() => _currentProxy;

  //
  bool clearCookies() {
    if (_cookieManager == null) return false;

    _cookieManager!.cookieJar.deleteAll();

    return true;
  }
}
