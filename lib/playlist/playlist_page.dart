import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:FlutterCloudMusic/lodable_state.dart';
import 'package:FlutterCloudMusic/model/playlist.dart';
import 'package:FlutterCloudMusic/music_player/music_player_page.dart';
import 'package:FlutterCloudMusic/network/Result.dart';
import 'package:FlutterCloudMusic/network/network.dart';
import 'package:FlutterCloudMusic/playlist/song_row.dart';
import 'package:FlutterCloudMusic/util/cmcolor.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:FlutterCloudMusic/util/constants.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;
  final String playlistId;
  const PlaylistPage({
    Key key,
    this.playlist,
    this.playlistId
  }) : super(key: key);
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends LoadableState<PlaylistPage> {
  int selectedIndex;
  @override
  void initState() {
    super.initState();
    // getPlaylist().then((result) {
    //   if (result.isSuccess) {
    //     playlist = result.result;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            stretch: true,
            title: CMText(text: "歌单", color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: headerTitle,
              stretchModes: [
                StretchMode.zoomBackground
              ],
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.playlist.avatarUrl),
                    fit: BoxFit.cover
                  )
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(28, 28, 28, 0.73)
                    ),
                  ),
                ),
              )
            ),
          ), 
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  return listTitle;
                }
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index - 1;
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => MusicPlayerPage(song:  widget.playlist.songs[index-1],))
                        );
                      });
                    },
                    child: Column(
                    children: [
                      SongRow(index: index, song: widget.playlist.songs[index-1], selected: selectedIndex == (index - 1),),
                      Divider(
                        color: Color(0x493C3C43),
                        height: 0.3,
                      )
                    ],
                  ),
                );
              },
              childCount: widget.playlist.songs.length + 1
            ),
          )
        ],
      ),
    );
  }

  final transformScale = 1.5;

  get playlistFunctions {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        functionItem("share", "200"),
        functionItem("share", "0"),
        functionItem("share", "下载"),
        functionItem("share", "排行榜")
      ],
    );
  }

  functionItem(String imageName, String text) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CMImage.named(imageName, width: 24 / transformScale, height: 24 / transformScale, color: Colors.white),
          Container(
            height: 26 / transformScale,
            child:  Center(child: CMText(text: text, color: Colors.white, fontSize: 14 / transformScale)),
          )
        ]
      ),
    );
  }

  get headerTitle {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 20 / transformScale),
            CachedNetworkImage(imageUrl: widget.playlist.avatarUrl, width: 140 / transformScale, height: 140 / transformScale),
            SizedBox(width: 10 / transformScale),
            Container(
              height: 140 / transformScale,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: (1.sw - 20 - 140 - 10 - 20) / transformScale,
                    child: CMText(text: widget.playlist.name, color: Colors.white, fontSize: 17 / transformScale),
                    height: 70 / transformScale,
                  ),
                  Container(
                    height: 70 / transformScale,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(imageUrl: widget.playlist.creator.avatarUrl, width: 30 / transformScale, height: 30 / transformScale),
                        ),
                        SizedBox(width: 10 / transformScale),
                        CMText(text: widget.playlist.creator.nickname, color: Colors.white, fontSize: 17 / transformScale)
                      ],
                    ),
                  )
                ]
              ) ,
            ),
            SizedBox(width:20 / transformScale)
          ],
        ), 
        SizedBox(height: 20 / transformScale),
        playlistFunctions
      ],
    );
  }
  
  get listTitle {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CMImage.named("ic_music_play_all", width: 44, height: 44),
          SizedBox(width: 10),
          CMText(text: "播放全部", fontSize: 17,),
          SizedBox(width: 15),
          CMText(text: "(共${widget.playlist.songs.length}首)", color: CMColor.white(0.67), fontSize: 14,),
          Expanded(child: Container()),
          Container(
            color: ColorComponent.red,
            width: 100,
            height: 55,
            child: Center(child: 
              CMText(text: "收藏", color: Colors.white, fontSize: 17,)
            ),
          )
        ],
      ),
    );
  }

}
