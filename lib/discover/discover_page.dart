import 'dart:convert';

import 'package:FlutterCloudMusic/discover/home_recommend.dart';
import 'package:FlutterCloudMusic/music_player/music_player_page.dart';
import 'package:FlutterCloudMusic/network/Result.dart';
import 'package:FlutterCloudMusic/playlist/playlist_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:FlutterCloudMusic/discover/discover_navigation_bar.dart';
import 'package:FlutterCloudMusic/lodable_state.dart';
import 'package:FlutterCloudMusic/model/playlist.dart';
import 'package:FlutterCloudMusic/model/song.dart';
import 'package:FlutterCloudMusic/network/network.dart';
import 'package:FlutterCloudMusic/util/cmcolor.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';

import 'discover_navigation_bar.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends LoadableState<DiscoverPage> {
  @override
  void initState() {
    super.initState();
    getRecommend();
  }

  HomeRecommend recommend;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DiscoverNavigationBar(), 
          headerButtons(context),
          title("每日推荐"),
          if (recommend != null) playListRecommend,
          title("推荐单曲"),
          if (recommend != null) songList
        ],
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
        physics: NeverScrollableScrollPhysics(),
        itemCount: 4,
        shrinkWrap: true,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      height: 80,
      width: MediaQuery.of(context).size.width - 24,
    );
  }

  title(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: CMText(text: text,fontSize: 17,),
      ),
    );
  }

  get playListRecommend {
    double itemWidth = ((1.sw - 60) / 3).floor().toDouble();
    double itemHeight = itemWidth + 10 + 17 * 2 * 1.7;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          childAspectRatio: itemWidth / itemHeight
        ), 
        itemBuilder: (ctx, index) {
          final playlist = recommend.playlists[index];
          final item = Column(
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: playlist.avatarUrl,
                    width: itemWidth,
                    height: itemWidth,
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CMImage.named("ClickCount", width: 15, height: 15),
                        SizedBox(width: 5),
                        CMText(text: '22087', color: Colors.white, fontSize: 14)
                      ],
                    )
                  ),
                ]
              ),
              SizedBox(height: 10),
              Container(
                width: itemWidth,
                child: CMText(text: playlist.name, fontSize: 17, maxLines: 2,),
              ),
              SizedBox(height: 10)
            ],
          );
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => PlaylistPage(playlist: playlist,))
              );
            },
            child: item,
          );
        },
        itemCount: recommend.playlists.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  get songList {
    return ListView.builder(itemBuilder: (ctx, index) {
      final song = recommend.songs[index];
      final item = Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Container(
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: song.imgUrl,
                width: 110,
                height: 110,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children:[
                  CMText(text: song.name, fontSize: 17,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CMImage.named("ClickCountNight", width: 15, height: 15),
                      CMText(text: "1", color: CMColor.white(0.67), fontSize: 12,)
                    ],
                  ),
                  Divider(height: 1, color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: song.artist.avatarUrl,
                          width: 24,
                          height: 24,
                        ),
                      ),
                      SizedBox(width: 5),
                      CMText(text: song.artist.nickname, fontSize: 14,)
                    ]
                  )
                ]
              )
            ],
          ),
        ),
      );
      return GestureDetector(
        child: item,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MusicPlayerPage(song: song,))),
      );
    },
    itemCount: recommend.songs.length,
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    );
  }

  getRecommend() async {
    try {
      final response = await dio.get('api/home/recommend');
      final result = Result.success(HomeRecommend.fromMap(response.data));
      if (result.isSuccess) {
        setState(() {
          recommend = result.result;
        });
      }
    } on DioError catch (error) {
      return Result.error(error);
    }
  }


}


