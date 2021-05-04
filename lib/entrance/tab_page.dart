import 'package:FlutterCloudMusic/discover/discover_page.dart';
import 'package:FlutterCloudMusic/login/welcome_page.dart';
import 'package:FlutterCloudMusic/mine/mine_page.dart';
import 'package:FlutterCloudMusic/model/app_state.dart';
import 'package:FlutterCloudMusic/moments/moments_feed_page.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:FlutterCloudMusic/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TabPage extends StatefulWidget {
  const TabPage({
    Key key,
  }) : super(key: key);
  @override
  TabPageState createState() => TabPageState();
}

class TabPageState extends State<TabPage> {
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: themeData.bottomBarColor,
        unselectedItemColor: RGBAColor(0x666666ff),
        currentIndex: currentIndex,
        items: _bottomTabs,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: StoreConnector<AppState, ThemeData>(
        converter: (store) => store.state.themeData,
        builder: (context, theme) {
          return _tabs(context)[currentIndex];
        },
        distinct: true,
      )
    );
    return WillPopScope(child: scaffold, onWillPop: () async => false);
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
    BottomBarItem(imageName: "images/Moments", title: "动态"),
    BottomBarItem(imageName: "images/tabbar/tab_mine", title: "我的")
  ];
  return items
      .map((item) => BottomNavigationBarItem(
          icon: Container(
              child: Image.asset(item.imageName + "_normal.png",),
              width: 35,
              height: 35),
          activeIcon: Container(
              child: Image.asset(item.imageName + "_normal.png", color: ColorComponent.red,),
              width: 35,
              height: 35),
          label: item.title))
      .toList();
}();
// AnnotatedRegion 用于更改 status bar 颜色
List<Widget> _tabs(BuildContext context) { 
  final brightness = AppState.of(context).themeData.appBarTheme.brightness;
  return [AnnotatedRegion<SystemUiOverlayStyle>(
    child: DiscoverPage(),
    value: SystemUiOverlayStyle(statusBarBrightness: brightness),
  ), MomentsFeedPage(), MinePage()];
}