import 'package:FlutterCloudMusic/utils.dart';
import 'package:flutter/material.dart';

final themeDataReducer = combineReducers<ThemeData>([
  TypedReducer<ThemeData, LightThemeAction>(_lightTheme),
  TypedReducer<ThemeData, DarkThemeAction>(_darkTheme)
]);
ThemeData lightTheme = (){
 var themeData = ThemeData.light();
  final copyedTheme = themeData.copyWith(
    appBarTheme: themeData.appBarTheme.copyWith(brightness: Brightness.light)
  );
  return copyedTheme;
}();

ThemeData darkTheme = (){
 var themeData = ThemeData.dark();
  final copyedTheme = themeData.copyWith(
    appBarTheme: themeData.appBarTheme.copyWith(brightness: Brightness.dark)
  );
  return copyedTheme;
}();

ThemeData _lightTheme(ThemeData state, action) {
  print("Theme is Light");
  return lightTheme;
}

ThemeData _darkTheme(ThemeData state, action) {
  print("Theme is Dark");
 return darkTheme;
}