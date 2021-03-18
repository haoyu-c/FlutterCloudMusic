import 'package:FlutterCloudMusic/login/token.dart';
import 'package:FlutterCloudMusic/model/account.dart';
import 'package:FlutterCloudMusic/model/app_state.dart';
import 'package:FlutterCloudMusic/network/network.dart';
import 'package:FlutterCloudMusic/redux/actions.dart';
import 'package:FlutterCloudMusic/util/navigation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account_handler.dart';

List<Middleware<AppState>> createMiddlewares(
  AccountHandler handler
) {
  final accountLogin = _createAccountLogin(handler);
  final saveAccount = _createSaveAccount();
  final getUserInfo = _createGetUserInfo(handler);
  final loadAccount = _createLoadAccount();
  return [
    TypedMiddleware<AppState, LoginAction>(accountLogin),
    TypedMiddleware<AppState, SaveAccountAction>(saveAccount),
    TypedMiddleware<AppState, GetUserInfoAction>(getUserInfo),
    TypedMiddleware<AppState, AccountLoadAction>(loadAccount)
  ];
}

Middleware<AppState> _createAccountLogin(AccountHandler handler) {
  return (Store<AppState> store, action, NextDispatcher next) {
    handler.login(action)
    .then((token) {
      Navigator.pop(action.context);
      store.dispatch(LoginSuccessAction(token: token));
      store.dispatch(SaveAccountAction(token: token));
      defaultNavigator.pushNamed(Routes.tabPage);
    })
    .catchError(
      (error) {
        Navigator.pop(action.context);
        var errorInfo = NetworkErrorInfo.fromError(error).reason;
        if (errorInfo.isEmpty) {
          errorInfo = "登陆发生了未知错误";
        }
        store.dispatch(LoginFailureAction(failureInfo: errorInfo));
      }
    );
    next(action);
  };
}

Middleware<AppState> _createSaveAccount() {
  return (Store<AppState> store, action, NextDispatcher next) {
    final saveAccountAction = action as SaveAccountAction;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("token", saveAccountAction.token.toJson());
    });
    next(action);
  };
}

Middleware<AppState> _createGetUserInfo(AccountHandler handler) {
  return (Store<AppState> store, action, NextDispatcher next) {
    handler.getUserInfo(action).then((user) {
      store.dispatch(UserInfoLoadedAction(user: user));
    });
    next(action);
  };
}

Middleware<AppState> _createLoadAccount() {
  return (Store<AppState> store, action, NextDispatcher next) {
    SharedPreferences.getInstance().then((prefs) {
      final tokenJson = prefs.getString("token");
      if (tokenJson != null) {
        final token = Token.fromJson(tokenJson);
        store.dispatch( AccountLoadedAction(token: token) );
      }
    });
    next(action);
  };
}