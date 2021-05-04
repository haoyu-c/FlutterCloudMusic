import 'dart:async';
import 'dart:ui';
import 'package:FlutterCloudMusic/component/fade_indexed_stack.dart';
import 'package:FlutterCloudMusic/model/play_songs_model.dart';
import 'package:FlutterCloudMusic/model/song.dart';
import 'package:FlutterCloudMusic/music_player/lyric_page.dart';
import 'package:FlutterCloudMusic/network/network.dart';
import 'package:FlutterCloudMusic/util/cmcolor.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:FlutterCloudMusic/util/downloader.dart';
import 'package:FlutterCloudMusic/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

import 'package:provider/provider.dart';

enum PlayerState { stopped, playing, paused }

class PlayerWidget extends StatefulWidget {
  final Song song;

  const PlayerWidget({
    Key key,
    @required this.song,
  }) : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> with TickerProviderStateMixin {
  bool showLyric = false;
  int switchIndex = 0;
  _PlayerWidgetState();

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaySongsModel>(
          builder: (context, model, child) {
            if (model.curState == AudioPlayerState.PLAYING) {
              controller1.repeat();
              controller2.forward();
            } else {
              controller1.stop();
              controller2.reverse();
            }
            final indexedStack = FadeIndexedStack(
              index: switchIndex,
              children: [
                AnimatedBuilder(animation: controller1, builder: (ctx, child){
                  return buildMusicCircle();
                }),
                LyricPage(model)
              ],
            );
            final column = Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        switchIndex = 1 - switchIndex;
                      });
                    },
                    child: indexedStack,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon("ic_like", 54),
                    icon("ic_music_previous", 71),
                    if (!model.isPlaying) icon("ic_music_play", 73, model.togglePlay) else icon("ic_music_pause", 73, model.togglePlay),
                    icon("ic_music_next", 51),
                    Expanded(
                      child: GestureDetector(
                        child: Icon(Icons.file_download, color: Colors.white,),
                        onTap: () {
                          context.read<Downloader>().requestDownload(name: widget.song.name, url: widget.song.songUrl);
                        } ,
                      )
                    )
                  ]
                ),
                Row(
                  children: [
                    SizedBox(width: 20),
                    StreamBuilder(
                      stream: model.curPositionStream ,
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        return CMText(text: model.positionText ?? "00:00", color: Colors.white);
                      },
                    ),
                    Expanded(
                      child: StreamBuilder<String>(
                        stream: model.curPositionStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var totalTime = double.parse(snapshot.data.substring(snapshot.data.indexOf('-') + 1));
                            var curTime = double.parse(snapshot.data.substring(0, snapshot.data.indexOf('-')));
                            return Slider(
                              onChanged: (v) {
                                final position = v * model.curSongDuration.inMilliseconds;
                                model.seekPlay(position.round());
                              },
                              value: curTime == 0 ? 0 : curTime / totalTime,
                            );
                          } else {
                            return Slider(
                              onChanged: (v) {
                                final position = v * model.curSongDuration.inMilliseconds;
                                model.seekPlay(position.round());
                              },
                              value: 0,
                            );
                          }
                        }
                      ),
                    ),
                    CMText(text: model.durationText ?? "", color: Colors.white),
                    SizedBox(width: 20)
                  ],
                ),
              ],
            );
            return column;
          },
    );
  }

  Stack buildMusicCircle() {
    return Stack(
        children: [
          Container(
            color: Colors.transparent,
            width: 1.sw,
            height: 600.sh,
          ),
          positionedImage("record_background_border"),
          Positioned(
            left: 20,
            top: 80,
            child: Transform(
              transform: Matrix4.rotationZ(rotation1.value),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CMImage.named("cd_bg", width: 1.sw - 40, height: 1.sw - 40),
                  ClipOval(
                    child: CachedNetworkImage(imageUrl: widget.song.imgUrl, width: (1.sw - 40) / 1.6, height: (1.sw - 40) / 1.6),
                  )
                ]
              ),
            ),
          ),
          Positioned(
            left: 1.sw / 2,
            top: 60,
            child: AnimatedBuilder(
              animation: controller2,
              builder: (ctx, child) {
                return Transform(
                  origin: Offset(0,0),
                  transform: Matrix4.rotationZ(rotation2.value),
                  child: CMImage.named('cd_thumb', width: 92, height: 138)
                );
              },
            ),
          )
        ],
      );
  }

  positionedWidget(Widget child) {
    return Positioned(
      left: 20,
      right: 20,
      top: 80,
      height: 1.sw - 40,
      child: child,
    );
  }

  positionedImage(String imageName) {
    return Positioned(
      left: 20,
      top: 80,
      child: Transform(
        transform: Matrix4.rotationZ(rotation1.value),
        alignment: Alignment.center,
        child: CMImage.named(imageName, width: 1.sw - 40, height: 1.sw - 40),
      ),
    );
  }

  icon(String name, double size, [VoidCallback onTap]) {
    return Expanded(
      child: GestureDetector(
        child: CMImage.named(name, width: size, height: size),
        onTap: onTap,
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  AnimationController controller1;
  Animation<double> rotation1;
  AnimationController controller2;
  Animation<double> rotation2;

  _initAnimation() {
    controller1 = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );
    rotation1 = Tween<double>(begin: 0, end: 2 * pi).animate(controller1);
    controller2 = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this
    );
    rotation2 = Tween<double>(begin: -0.15 * pi, end: - 0.03 * pi).animate(controller2);
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }
  
}