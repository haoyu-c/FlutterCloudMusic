import 'dart:convert';

import 'package:FlutterCloudMusic/login/token.dart';
import 'package:FlutterCloudMusic/model/user.dart';

class Account {
  User user;
  Token token;
  Account({
    this.user,
    this.token,
  });

  @override
  String toString() => 'Account(user: $user, token: $token)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Account &&
      o.user == user &&
      o.token == token;
  }

  @override
  int get hashCode => user.hashCode ^ token.hashCode;

  Account copyWith({
    User user,
    Token token,
  }) {
    return Account(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'token': token?.toMap(),
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Account(
      user: User.fromMap(map['user']),
      token: Token.fromMap(map['token']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) => Account.fromMap(json.decode(source));
}
