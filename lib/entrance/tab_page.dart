import 'package:FlutterCloudMusic/discover/discover_page.dart';
import 'package:FlutterCloudMusic/login/welcome_page.dart';
import 'package:FlutterCloudMusic/mine/mine_page.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: Colors.white,
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
      body: _tabs[currentIndex]
    );
    return WillPopScope(child: scaffold, onWillPop: () async => false);
  }
  get title {
    if (currentIndex == 0) {
      return CMText(text: "发现");
    } else {
      return CMText(text: "我的");
    }
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
// AnnotatedRegion 用于更改 status bar 颜色
final _tabs = [AnnotatedRegion<SystemUiOverlayStyle>(
  child: DiscoverPage(),
  value: SystemUiOverlayStyle.dark,
  ), MinePage()];