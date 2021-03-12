import 'dart:convert';

import 'package:FlutterCloudMusic/model/user.dart';

class Comment {
  String id;
  String content;
  User user;
  int replyCount;
  int likeCount;
  List<CommentReply> replies;
  int time;
  Comment({
    this.id,
    this.content,
    this.user,
    this.replyCount,
    this.likeCount,
    this.replies,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'user': user?.toMap(),
      'replyCount': replyCount,
      'likeCount': likeCount,
      'replies': replies?.map((x) => x?.toMap())?.toList(),
      'time': time,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Comment(
      id: map['id'],
      content: map['content'],
      user: User.fromMap(map['user']),
      replyCount: map['replyCount'],
      likeCount: map['likeCount'],
      replies: List<CommentReply>.from(map['replies']?.map((x) => CommentReply.fromMap(x))),
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source));
}

class CommentReply {
  String id;
  String parentCommentId;
  String content;
  User user;
  int likeCount;
  int time;
  CommentReply({
    this.id,
    this.parentCommentId,
    this.content,
    this.user,
    this.likeCount,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentCommentId': parentCommentId,
      'content': content,
      'user': user?.toMap(),
      'likeCount': likeCount,
      'time': time,
    };
  }

  factory CommentReply.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CommentReply(
      id: map['id'],
      parentCommentId: map['parentCommentId'],
      content: map['content'],
      user: User.fromMap(map['user']),
      likeCount: map['likeCount'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentReply.fromJson(String source) => CommentReply.fromMap(json.decode(source));
}
