import 'package:FlutterCloudMusic/model/song.dart';
import 'package:FlutterCloudMusic/util/cmcolor.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:flutter/material.dart';

class SongRow extends StatelessWidget {
  final Song song;
  final int index;
  final bool selected;
  SongRow({this.song, this.index, this.selected});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: 10),
          Container(
            width: 55,
            height: 55,
            child: Center(
              child: selected 
              ? CMImage.named("CurentPlay", width: 30, height: 30)
              : CMText(
                text: index.toString(), 
                color: CMColor.white(0.67),
                fontSize: 17,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CMText(
                  text: song.name,
                  color: selected ? Color(0xffdd0000) : Colors.black,
                  fontSize: 17,
                ),
                CMText(
                  text: song.artist.nickname,
                  color: CMColor.white(0.67),
                  fontSize: 14,
                )
              ],
            ),
          ),
          SizedBox(width: 20),
          CMImage.named("More", width: 32, height: 32),
          SizedBox(width: 20)
        ],
      ),
    );
  }
}