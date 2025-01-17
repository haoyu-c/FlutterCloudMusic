import 'dart:convert';

import 'package:FlutterCloudMusic/network/Result.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'dart:io' show Platform;
get baseUrl async {
  if (Platform.isAndroid) {
    // final deviceInfo = await DeviceInfoPlugin().androidInfo;
    // if (deviceInfo.isPhysicalDevice) {
    //   return "http://13.88.217.75:80/";
    // } else {
    //   return "http://10.0.2.2:8080/";
    // }
    return "http://13.88.217.75:80/";
  }
  final deviceInfo = await DeviceInfoPlugin().iosInfo;
  if (deviceInfo.isPhysicalDevice) {
    return "http://13.88.217.75:80/";
  } else {
    return "http://127.0.0.1:8080/";
  }
}
Future<Dio> get dioFuture async {
    return Dio(BaseOptions(baseUrl: await baseUrl))
  ..interceptors.add(LogInterceptor());
}

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

class Network {
  static Future<DioError> postComment(Map<String, dynamic> params) async {
    try {
      await (await dioFuture).post("comments", queryParameters: params);
      return null;
    } on DioError catch (error) {
      return error;
    }
  }
}