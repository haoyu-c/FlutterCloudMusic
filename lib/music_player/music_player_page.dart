import 'dart:io';
import 'dart:ui';

import 'package:FlutterCloudMusic/music_player/player_widget.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MusicPlayerPage extends StatefulWidget {
  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();


  @override
  void initState() { 
    super.initState();
    if (Platform.isIOS) {
      // if (audioCache.fixedPlayer != null) {
      //   audioCache.fixedPlayer.startHeadlessService();
      // }
      // audioPlayer.startHeadlessService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(CMImage.imageNamed("chengdu", suffix: "jpg")),
                fit: BoxFit.cover,
              )
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Color.fromRGBO(28, 28, 28, 0.73),
                child: SafeArea(child: PlayerWidget(url: "http://127.0.0.1:8080/api/songs/file/chengdu.mp3")),
              ),
            ),
          )
        ],
      ),
    );
  }
  
  AppBar get appBar {  
    return AppBar(
      title: CMText(
        text: "成都-赵雷",
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CMImage.named("share", color: Colors.white, width: 24,height: 24),
          ),
        )
      ],
    );
  }
}
