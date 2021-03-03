import 'dart:convert';

class TokenUser {
  final String id;
  TokenUser({
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory TokenUser.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TokenUser(
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TokenUser.fromJson(String source) =>
      TokenUser.fromMap(json.decode(source));
}

class Token {
  final String id;
  final String value;
  final TokenUser user;
  Token({
    this.id,
    this.value,
    this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
      'user': user?.toMap(),
    };
  }

  factory Token.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Token(
      id: map['id'],
      value: map['value'],
      user: TokenUser.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Token.fromJson(String source) => Token.fromMap(json.decode(source));
}
