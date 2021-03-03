import 'package:FlutterCloudMusic/discover/discover_navigation_bar.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'discover_navigation_bar.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  var data;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [DiscoverNavigationBar(), headerButtons(context)],
      ),
    );
  }

  Container headerButtons(BuildContext context) {
    final images = ["IconDay", "IconSheet", "IconFMSelected", "IconRank"];
    final texts = ["每日推荐", "歌单", "私人FM", "排行榜"];
    return Container(
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.transparent)),
                onPressed: () {},
                child: Column(children: [
                  Container(
                    child: CMImage.named(images[index]),
                    width: 50,
                    height: 50,
                  ),
                  CMText(
                    text: texts[index],
                    fontName: "PingFangSC-Regular",
                    fontSize: 17,
                    height: 1.5,
                  )
                ]),
              ),
            ),
            height: 80,
            width: 50,
          );
        },
        itemCount: 4,
        shrinkWrap: true,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      height: 80,
      width: MediaQuery.of(context).size.width - 24,
    );
  }

  Widget getDateText() {
    final formatter = DateFormat("dd");
    return CMText(text: formatter.format(DateTime.now()), fontSize: 18);
  }

  loadData() async {
    setState(() {});
  }
}
