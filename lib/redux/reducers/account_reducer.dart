import 'package:FlutterCloudMusic/model/account.dart';
import 'package:FlutterCloudMusic/redux/actions.dart';
import 'package:redux/redux.dart';

final accountReducer = combineReducers<Account>([
  TypedReducer<Account, LogoutAction>(_logout),
  TypedReducer<Account, LoginSuccessAction>(_loginSuccess),
  TypedReducer<Account, AccountLoadedAction>(_loginSuccess),
  TypedReducer<Account, UserInfoLoadedAction>(_saveUserInfo)
]);

Account _loginSuccess(Account state, action) {
  return state.copyWith(token: action.token);
}

Account _logout(Account state, action) {
  return Account();
}

Account _saveUserInfo(Account state, action) {
  return state.copyWith(user: action.user);
}