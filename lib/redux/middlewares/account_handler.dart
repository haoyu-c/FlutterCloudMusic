import 'dart:convert';

import 'package:FlutterCloudMusic/login/token.dart';
import 'package:FlutterCloudMusic/model/user.dart';
import 'package:FlutterCloudMusic/network/network.dart';
import 'package:FlutterCloudMusic/redux/actions.dart';
import 'package:FlutterCloudMusic/util/cmdialog.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountHandler {
  Future<Token> login(LoginAction action) async {
    CMDialog.showLoadingDialog(action.context);
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('${action.username}:${action.password}'));
    final response = await (await dioFuture).post('api/users/login',
          options:
              Options(headers: <String, String>{'authorization': basicAuth}));
   return Token.fromMap(response.data);
  }

  Future<User> getUserInfo(GetUserInfoAction action) async {
    final response = await (await dioFuture).get('api/users/' + action.userId,);
    return User.fromMap(response.data);
  }
}