import 'dart:convert';

class Artist {

    String id;
    String nickname;
    String avatarUrl;
    String schema;
  Artist({
    this.id,
    this.nickname,
    this.avatarUrl,
    this.schema,
  });
    

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'avatarUrl': avatarUrl,
      'schema': schema,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Artist(
      id: map['id'],
      nickname: map['nickname'],
      avatarUrl: map['avatarUrl'],
      schema: map['schema'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) => Artist.fromMap(json.decode(source));
}
