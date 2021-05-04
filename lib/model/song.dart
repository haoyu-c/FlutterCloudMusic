import 'dart:convert';

import 'package:FlutterCloudMusic/model/artist.dart';
import 'package:FlutterCloudMusic/util/downloader.dart';
import 'package:FlutterCloudMusic/utils.dart';

class Song {
  String id;
  Artist artist;
  String songUrl;
  String name;
  String lyricName;
  int duration;
  String imgUrl;
  String localPath;
  bool get isLocal  {
    return !(localPath == null || localPath == "");
  }

  Song({
    this.id,
    this.artist,
    this.songUrl,
    this.name,
    this.lyricName,
    this.duration,
    this.imgUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'artist': artist?.toMap(),
      'songUrl': songUrl,
      'name': name,
      'lyricName': lyricName,
      'duration': duration,
      'imgUrl': imgUrl,
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'artistId': artist?.id,
      'songUrl': songUrl,
      'name': name,
      'lyricName': lyricName,
      'duration': duration,
      'imgUrl': imgUrl
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Song(
      id: map['id'],
      artist: Artist.fromMap(map['artist']),
      songUrl: map['songUrl'],
      name: map['name'],
      lyricName: map['lyricName'],
      duration: map['duration'],
      imgUrl: map['imgUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source));
}
