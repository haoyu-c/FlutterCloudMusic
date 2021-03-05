import 'dart:convert';

import 'package:FlutterCloudMusic/model/playlist.dart';
import 'package:FlutterCloudMusic/model/song.dart';

class HomeRecommend {
  List<Playlist> playlists;
  List<Song> songs;
  HomeRecommend({
    this.playlists,
    this.songs,
  });

  Map<String, dynamic> toMap() {
    return {
      'playlists': playlists?.map((x) => x?.toMap())?.toList(),
      'songs': songs?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory HomeRecommend.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return HomeRecommend(
      playlists: List<Playlist>.from(map['playlists']?.map((x) => Playlist.fromMap(x))),
      songs: List<Song>.from(map['songs']?.map((x) => Song.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeRecommend.fromJson(String source) => HomeRecommend.fromMap(json.decode(source));
}