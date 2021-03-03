import 'package:FlutterCloudMusic/login/register_page.dart';
import 'package:FlutterCloudMusic/music_player/music_player_page.dart';
import 'package:FlutterCloudMusic/playlist/playlist_page.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:FlutterCloudMusic/util/constants.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [text(), loginButton(), registerButton()]),
      ),
    );
  }

  Widget loginButton() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: Builder(
          builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return PlaylistPage();
                  // return MusicPlayerPage();
                  // return Scaffold(body: LoginPage());
                }));
              },
              style: ElevatedButton.styleFrom(
                  primary: ColorComponent.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: CMText(
                  text: "登陆",
                  fontName: "PingFangSC-Regular",
                  fontSize: 18,
                  color: Colors.white,
                ),
              )),
        ));
  }

  Widget registerButton() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: Builder(
          builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return Scaffold(body: RegisterPage());
                }));
              },
              style: ElevatedButton.styleFrom(
                  primary: ColorComponent.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: CMText(
                  text: "注册",
                  fontName: "PingFangSC-Regular",
                  fontSize: 18,
                  color: Colors.white,
                ),
              )),
        ));
  }

  Widget text() {
    return CMText(
        text: "我的云音乐",
        color: ColorComponent.red,
        fontSize: 24,
        fontWeight: FontWeight.bold);
  }
}
