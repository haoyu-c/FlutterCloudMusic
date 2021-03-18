import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static final Application shared = Application();
  SharedPreferences sp;
  Dio dio;

  init() async {
    sp = await SharedPreferences.getInstance();
    dio = await dio;
  }
}