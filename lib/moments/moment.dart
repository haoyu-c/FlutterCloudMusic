import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:FlutterCloudMusic/model/user.dart';

class Moment {

    List<String> images;
    String content;
    User user;
    String id;
    String location;
    int likeCount;
    int postCount;
    int commentCount;
    int createAt;
  Moment({
    this.images,
    this.content,
    this.user,
    this.id,
    this.location,
    this.likeCount,
    this.postCount,
    this.commentCount,
    this.createAt,
  });

  Moment copyWith({
    List<String> images,
    String content,
    User user,
    String id,
    String location,
    int likeCount,
    int postCount,
    int commentCount,
    double createAt,
  }) {
    return Moment(
      images: images ?? this.images,
      content: content ?? this.content,
      user: user ?? this.user,
      id: id ?? this.id,
      location: location ?? this.location,
      likeCount: likeCount ?? this.likeCount,
      postCount: postCount ?? this.postCount,
      commentCount: commentCount ?? this.commentCount,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'images': images,
      'content': content,
      'user': user?.toMap(),
      'id': id,
      'location': location,
      'likeCount': likeCount,
      'postCount': postCount,
      'commentCount': commentCount,
      'createAt': createAt,
    };
  }

  factory Moment.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Moment(
      images: List<String>.from(map['images']),
      content: map['content'],
      user: User.fromMap(map['user']),
      id: map['id'],
      location: map['location'],
      likeCount: map['likeCount'],
      postCount: map['postCount'],
      commentCount: map['commentCount'],
      createAt: map['createAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Moment.fromJson(String source) => Moment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Moment(images: $images, content: $content, user: $user, id: $id, location: $location, likeCount: $likeCount, postCount: $postCount, commentCount: $commentCount, createAt: $createAt)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Moment &&
      listEquals(o.images, images) &&
      o.content == content &&
      o.user == user &&
      o.id == id &&
      o.location == location &&
      o.likeCount == likeCount &&
      o.postCount == postCount &&
      o.commentCount == commentCount &&
      o.createAt == createAt;
  }

  @override
  int get hashCode {
    return images.hashCode ^
      content.hashCode ^
      user.hashCode ^
      id.hashCode ^
      location.hashCode ^
      likeCount.hashCode ^
      postCount.hashCode ^
      commentCount.hashCode ^
      createAt.hashCode;
  }
}
