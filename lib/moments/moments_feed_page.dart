import 'package:FlutterCloudMusic/entrance/application.dart';
import 'package:FlutterCloudMusic/moments/moment.dart';
import 'package:FlutterCloudMusic/moments/moment_post_page.dart';
import 'package:FlutterCloudMusic/moments/moment_row.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class MomentsFeedPage extends StatefulWidget {
  @override
  _MomentsFeedPageState createState() => _MomentsFeedPageState();
}

class _MomentsFeedPageState extends State<MomentsFeedPage> {

  List<Moment> moments = [];

  @override
  void initState() { 
    super.initState();
    Application.shared.dio.get("api/moments/all").then((response) {
      List momentsData = response.data;
      final moments = momentsData.map((e) => Moment.fromMap(e)).toList();
      setState(() {
        if (moments.isNotEmpty) {
          this.moments = moments;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: momentsFeed,
    );
  }

  Widget get momentsFeed {
    return ListView.builder(
      itemBuilder: (context, index) {
        return MomentRow(moment: moments[index]);
      },
      itemCount: moments.length,
      shrinkWrap: true,
    );
  }

  AppBar get appBar {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: blackWhiteBg,
      title: CMText(text: "动态"),
      elevation: 0,
      brightness: ThemeDataExtension.appBar(context),
      actions: [
        IconButton(
          icon: Icon(Icons.add_circle_outline), 
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return MomentPostPage();
              })
            );
          }
        )
      ],
    );
  }
}