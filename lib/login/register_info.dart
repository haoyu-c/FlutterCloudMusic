import 'dart:convert';

class RegisterInfo {
  String username;
  String password;
  String email;
  RegisterInfo({
    this.username,
    this.password,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
    };
  }

  factory RegisterInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RegisterInfo(
      username: map['username'],
      password: map['password'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterInfo.fromJson(String source) =>
      RegisterInfo.fromMap(json.decode(source));
}
