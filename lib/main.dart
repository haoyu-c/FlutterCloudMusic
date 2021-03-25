import 'package:FlutterCloudMusic/app.dart';
import 'package:FlutterCloudMusic/entrance/application.dart';
import 'package:FlutterCloudMusic/entrance/tab_page.dart';
import 'package:FlutterCloudMusic/login/welcome_page.dart';
import 'package:FlutterCloudMusic/model/app_state.dart';
import 'package:FlutterCloudMusic/redux/middlewares/middlewares.dart';
import 'package:FlutterCloudMusic/redux/reducers/app_state_reducer.dart';
import 'package:FlutterCloudMusic/redux/reducers/theme_data_reducer.dart';
import 'package:FlutterCloudMusic/util/navigation.dart';
import 'package:FlutterCloudMusic/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'discover/discover_page.dart';
import 'model/account.dart';
import 'model/play_songs_model.dart';
import 'redux/middlewares/account_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = MyApp();
  await Application.shared.init();
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
      initialState: AppState(account: Account(), themeData: (Application.shared.sp.getBool(Keys.isDarkTheme) ?? false) ? darkTheme : lightTheme),
      middleware: createMiddlewares(AccountHandler())
    );
    final app = MaterialApp(
      debugShowCheckedModeBanner: false,
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
          return TabPage(key: Keys.tabKey);
        }
      },
    );
    return StoreProvider(
      store: store,
      child: app,
    );
  }
}
