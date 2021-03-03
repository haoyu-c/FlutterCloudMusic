import 'package:FlutterCloudMusic/network/network.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

class ErrorInterceptors extends InterceptorsWrapper {
  final Dio dio;
  ErrorInterceptors({
    this.dio,
  });

  @override
  Future onRequest(RequestOptions options) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      final error = DioError(
          response: Response(
              data: NetworkErrorInfo(error: true, reason: "无网络连接").toMap()));
      return dio.reject(error);
    }
    return options;
  }
}
