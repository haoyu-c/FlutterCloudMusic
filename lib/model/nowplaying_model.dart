import 'package:FlutterCloudMusic/model/song.dart';
import 'package:flutter/material.dart';

enum NowPlayingMode {
  order, random, repeat
}

class NowPlayingModel extends ChangeNotifier {
  List<Song> list;
  int index;
  String name;
  NowPlayingMode mode;
}