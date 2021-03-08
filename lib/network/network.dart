import 'dart:convert';

import 'package:dio/dio.dart';

import 'ErrorInterceptors.dart';
// const baseUrl = "http://127.0.0.1:8080/";
const baseUrl = "http://193.123.246.233:80/";
final dio = Dio(BaseOptions(baseUrl: baseUrl))
..interceptors.add(ErrorInterceptors())
..interceptors.add(LogInterceptor());

class NetworkErrorInfo {
  bool error;
  String reason;
  NetworkErrorInfo({
    this.error,
    this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'error': error,
      'reason': reason,
    };
  }

  factory NetworkErrorInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return NetworkErrorInfo(
      error: map['error'],
      reason: map['reason'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NetworkErrorInfo.fromJson(String source) =>
      NetworkErrorInfo.fromMap(json.decode(source));

  factory NetworkErrorInfo.fromError(DioError error) =>
      NetworkErrorInfo.fromMap(error.response.data);
}
