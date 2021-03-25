import 'package:FlutterCloudMusic/network/network.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  // hide private initializer
  Application._();
  static final Application shared = Application._();
  SharedPreferences sp;
  Dio dio;

  init() async {
    sp = await SharedPreferences.getInstance();
    dio = await dioFuture;
  }
}