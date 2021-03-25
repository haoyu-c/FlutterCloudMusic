import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:FlutterCloudMusic/model/account.dart';
import 'package:FlutterCloudMusic/model/user.dart';

class AppState {
  final Account account;
  final ThemeData themeData;
  AppState({
    this.account,
    this.themeData,
  });

  static Store<AppState> storeOf(BuildContext context) {
    return StoreProvider.of<AppState>(context);
  }

  static AppState of(BuildContext context) {
    return StoreProvider.of<AppState>(context).state;
  }

  @override
  String toString() => 'AppState(account: $account, themeData: $themeData)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is AppState &&
      o.account == account &&
      o.themeData == themeData;
  }

  @override
  int get hashCode => account.hashCode ^ themeData.hashCode;

  AppState copyWith({
    Account account,
    ThemeData themeData,
  }) {
    return AppState(
      account: account ?? this.account,
      themeData: themeData ?? this.themeData,
    );
  }
  
}
