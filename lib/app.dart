import 'package:FlutterCloudMusic/discover/discover_page.dart';
import 'package:FlutterCloudMusic/login/login_page.dart';
import 'package:FlutterCloudMusic/login/welcome_page.dart';
import 'package:FlutterCloudMusic/mine/mine_page.dart';
import 'package:FlutterCloudMusic/music_player/music_player_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:flutter_screenutil/screenutil_init.dart';

import 'login/register_page.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    AudioPlayer.logEnabled = true;
    return ScreenUtilInit(
      designSize: Size(428, 926),
      builder: () {
        return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          items: _bottomTabs,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        body: _tabs[currentIndex]);
      },
    );
  }
}

class BottomBarItem {
  final imageName;
  final title;
  BottomBarItem({this.imageName, this.title});
}

final _bottomTabs = () {
  final items = [
    BottomBarItem(imageName: "images/tabbar/tab_discover", title: "发现"),
    BottomBarItem(imageName: "images/tabbar/tab_mine", title: "我的")
  ];
  return items
      .map((item) => BottomNavigationBarItem(
          icon: Container(
              child: Image.asset(item.imageName + "_normal.png"),
              width: 35,
              height: 35),
          activeIcon: Container(
              child: Image.asset(item.imageName + "_active.png"),
              width: 35,
              height: 35),
          label: item.title))
      .toList();
}();

final _tabs = [WelcomePage(), DiscoverPage()];
