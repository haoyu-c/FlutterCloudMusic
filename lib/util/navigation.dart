import 'package:FlutterCloudMusic/entrance/splash_page.dart';
import 'package:FlutterCloudMusic/entrance/tab_page.dart';
import 'package:flutter/material.dart';

class Keys {
  static final navKey = GlobalKey<NavigatorState>();
  static final splashKey = GlobalKey<SplashPageState>();
  static final tabKey = GlobalKey<TabPageState>();
  static final isDarkTheme = "isDarkTheme";
}

class Routes {
  static final discoverPage = "discoverPage";
  static final welcomePage = "welcomePage";
  static final tabPage = "tabPage";
}

NavigatorState get defaultNavigator {
  return Keys.navKey.currentState;
}