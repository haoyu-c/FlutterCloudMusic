import 'dart:convert';

class User {
  String id;
  String username;
  String avatarUrl;
  String backgroundAvatarUrl;
  String schema;
  String nickname;
  int followCount;
  int followerCount;
  User({
    this.id,
    this.username,
    this.avatarUrl,
    this.backgroundAvatarUrl,
    this.schema,
    this.nickname,
    this.followCount,
    this.followerCount,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'avatarUrl': avatarUrl,
      'backgroundAvatarUrl': backgroundAvatarUrl,
      'schema': schema,
      'nickname': nickname,
      'followCount': followCount,
      'followerCount': followerCount,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return User(
      id: map['id'],
      username: map['username'],
      avatarUrl: map['avatarUrl'],
      backgroundAvatarUrl: map['backgroundAvatarUrl'],
      schema: map['schema'],
      nickname: map['nickname'],
      followCount: map['followCount'],
      followerCount: map['followerCount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
