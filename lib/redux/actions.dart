import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:FlutterCloudMusic/login/token.dart';
import 'package:FlutterCloudMusic/model/user.dart';

class LoginAction {
  String username;
  String password;
  BuildContext context;
  LoginAction({
    this.username,
    this.password,
    this.context
  });
}

class LoginSuccessAction {
  Token token;
  LoginSuccessAction({
    this.token,
  });
}

class SaveAccountAction {
  Token token;
  SaveAccountAction({
    this.token,
  });
}

class LoginFailureAction {
  String failureInfo;
  LoginFailureAction({
    this.failureInfo,
  });
}

class LogoutAction {}

class RegisterAction {
  String username;
  String password;
  RegisterAction({
    this.username,
    this.password,
  });
}

class AccountLoadAction { }

class AccountLoadedAction {
  Token token;
  AccountLoadedAction({
    this.token,
  });
}

class GetUserInfoAction {
  String userId;
  GetUserInfoAction({
    this.userId,
  });
}

class UserInfoLoadedAction {
  User user;
  UserInfoLoadedAction({
    this.user,
  });
}
