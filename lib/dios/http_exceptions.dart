/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:37 下午
/// @Description: 自定义错误
class HttpDioException implements Exception {
  final String? _message;

  String get message => _message ?? this.runtimeType.toString();

  final int? _code;

  int get code => _code ?? -1;

  HttpDioException([this._message, this._code]);

  String toString() {
    return "code:$code--message=$message";
  }
}

/// 客户端请求错误
class BadRequestException extends HttpDioException {
  BadRequestException({String? message, int? code}) : super(message, code);
}

/// 服务端响应错误
class BadServiceException extends HttpDioException {
  BadServiceException({String? message, int? code}) : super(message, code);
}

class UnknownException extends HttpDioException {
  UnknownException([String? message]) : super(message);
}

class CancelException extends HttpDioException {
  CancelException([String? message]) : super(message);
}

class NetworkException extends HttpDioException {
  NetworkException({String? message, int? code}) : super(message, code);
}

/// 401
class UnauthorisedException extends HttpDioException {
  UnauthorisedException({String? message, int? code = 401}) : super(message);
}

class BadResponseException extends HttpDioException {
  dynamic? data;

  BadResponseException([this.data]) : super();
}
