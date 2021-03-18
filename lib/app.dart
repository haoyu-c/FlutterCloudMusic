import 'package:FlutterCloudMusic/entrance/splash_page.dart';
import 'package:FlutterCloudMusic/util/navigation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:redux/redux.dart';

import 'package:FlutterCloudMusic/discover/discover_page.dart';
import 'package:FlutterCloudMusic/login/login_page.dart';
import 'package:FlutterCloudMusic/login/welcome_page.dart';
import 'package:FlutterCloudMusic/mine/mine_page.dart';
import 'package:FlutterCloudMusic/music_player/music_player_page.dart';

import 'login/register_page.dart';
import 'model/app_state.dart';

class App extends StatefulWidget {
  final Store<AppState> store;
  const App({
    Key key,
    this.store,
  }) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    AudioPlayer.logEnabled = false;
    return ScreenUtilInit(
      designSize: Size(428, 926),
      builder: () {
        return SplashPage(key: Keys.splashKey);
      },
    );
  }
}


