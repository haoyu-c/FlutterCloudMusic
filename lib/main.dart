import 'package:FlutterCloudMusic/app.dart';
import 'package:FlutterCloudMusic/entrance/tab_page.dart';
import 'package:FlutterCloudMusic/login/welcome_page.dart';
import 'package:FlutterCloudMusic/model/app_state.dart';
import 'package:FlutterCloudMusic/redux/middlewares/account_handler_middleware.dart';
import 'package:FlutterCloudMusic/redux/reducers/app_state_reducer.dart';
import 'package:FlutterCloudMusic/util/navigation.dart';
import 'package:FlutterCloudMusic/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'discover/discover_page.dart';
import 'model/account.dart';
import 'model/play_songs_model.dart';
import 'redux/middlewares/account_handler.dart';

void main() {
  final app = MyApp();
  final provider = MultiProvider(
    providers: [
       ChangeNotifierProvider(create: (_) => PlaySongsModel()..init())
    ],
    child: app,
  );
  runApp(provider);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final store = Store<AppState>(
      appReducer,
      initialState: AppState(account: Account()),
      middleware: createMiddlewares(AccountHandler())
    );
    final app = MaterialApp(
      title: 'Flutter Cloud Music',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: App(store: store),
      navigatorKey: Keys.navKey,
      routes: {
        Routes.discoverPage: (context) {
          return DiscoverPage();
        },
        Routes.welcomePage: (context) {
          return WelcomePage();
        },
        Routes.tabPage: (context) {
          return TabPage();
        }
      },
    );
    return StoreProvider(
      store: store,
      child: app,
    );
  }
}
