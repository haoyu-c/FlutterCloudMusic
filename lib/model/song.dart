import 'dart:convert';
import 'package:FlutterCloudMusic/model/artist.dart';

class Song {
  String id;
  Artist artist;
  String songUrl;
  String name;
  String lyricUrl;
  String createdAt;
  Song({
    this.id,
    this.artist,
    this.songUrl,
    this.name,
    this.lyricUrl,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'artist': artist?.toMap(),
      'songUrl': songUrl,
      'name': name,
      'lyricUrl': lyricUrl,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'artistId': artist?.id,
      'songUrl': songUrl,
      'name': name,
      'lyricUrl': lyricUrl,
      'createdAt': createdAt,
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
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source));
}
