import 'package:FlutterCloudMusic/utils.dart';
import 'package:flutter/material.dart';

extension StateExtension on State {
  AppState get appState {
    return AppState.of(context);
  }

  Store<AppState> get store {
    return AppState.storeOf(context);
  }

  ThemeData get themeData {
    return appState.themeData;
  }

  TextTheme get textTheme {
    return themeData.textTheme;
  }

  bool get isLightTheme {
    return themeData.isLight;
  }

  Color get blackWhiteBg {
    return isLightTheme ? Colors.white : Colors.black;
  }
}