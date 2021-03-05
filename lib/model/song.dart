import 'dart:convert';

import 'package:FlutterCloudMusic/model/artist.dart';

class Song {
  String id;
  Artist artist;
  String songUrl;
  String name;
  String lyricUrl;
  int duration;
  String imgUrl;

  Song({
    this.id,
    this.artist,
    this.songUrl,
    this.name,
    this.lyricUrl,
    this.duration,
    this.imgUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'artist': artist?.toMap(),
      'songUrl': songUrl,
      'name': name,
      'lyricUrl': lyricUrl,
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
      'lyricUrl': lyricUrl,
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
      lyricUrl: map['lyricUrl'],
      duration: map['duration'],
      imgUrl: map['imgUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source));
}
