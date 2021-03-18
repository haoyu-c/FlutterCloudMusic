import 'package:FlutterCloudMusic/model/app_state.dart';
import 'package:FlutterCloudMusic/redux/reducers/account_reducer.dart';


AppState appReducer(AppState state, action) {
  return AppState(
    account: accountReducer(state.account, action)
  );
}