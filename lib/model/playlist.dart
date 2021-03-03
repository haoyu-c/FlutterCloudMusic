import 'dart:convert';

import 'song.dart';
import 'user.dart';

class Playlist {
    String id;
    String name;
    String avatarUrl;
    User creator;
    List<Song> songs;
  Playlist({
    this.id,
    this.name,
    this.avatarUrl,
    this.creator,
    this.songs,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'creator': creator?.toMap(),
      'songs': songs?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Playlist(
      id: map['id'],
      name: map['name'],
      avatarUrl: map['avatarUrl'],
      creator: User.fromMap(map['creator']),
      songs: List<Song>.from(map['songs']?.map((x) => Song.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source) => Playlist.fromMap(json.decode(source));
}
