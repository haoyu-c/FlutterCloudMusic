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

  @override
  String toString() {
    return 'User(id: $id, username: $username, avatarUrl: $avatarUrl, backgroundAvatarUrl: $backgroundAvatarUrl, schema: $schema, nickname: $nickname, followCount: $followCount, followerCount: $followerCount)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is User &&
      o.id == id &&
      o.username == username &&
      o.avatarUrl == avatarUrl &&
      o.backgroundAvatarUrl == backgroundAvatarUrl &&
      o.schema == schema &&
      o.nickname == nickname &&
      o.followCount == followCount &&
      o.followerCount == followerCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      avatarUrl.hashCode ^
      backgroundAvatarUrl.hashCode ^
      schema.hashCode ^
      nickname.hashCode ^
      followCount.hashCode ^
      followerCount.hashCode;
  }
}
