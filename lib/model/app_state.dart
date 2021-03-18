import 'package:FlutterCloudMusic/model/account.dart';
import 'package:FlutterCloudMusic/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AppState {
  final Account account;
  final bool isLoading;
  AppState({
    this.account,
    this.isLoading = false,
  });

  static Store<AppState> storeOf(BuildContext context) {
    return StoreProvider.of<AppState>(context);
  }

  static AppState of(BuildContext context) {
    return StoreProvider.of<AppState>(context).state;
  }

  @override
  String toString() => 'AppState(account: $account, isLoading: $isLoading)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is AppState &&
      o.account == account &&
      o.isLoading == isLoading;
  }

  @override
  int get hashCode => account.hashCode ^ isLoading.hashCode;
}
