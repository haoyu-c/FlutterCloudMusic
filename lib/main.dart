import 'package:FlutterCloudMusic/app.dart';
import 'package:FlutterCloudMusic/entrance/application.dart';
import 'package:FlutterCloudMusic/entrance/tab_page.dart';
import 'package:FlutterCloudMusic/login/welcome_page.dart';
import 'package:FlutterCloudMusic/model/app_state.dart';
import 'package:FlutterCloudMusic/redux/middlewares/middlewares.dart';
import 'package:FlutterCloudMusic/redux/reducers/app_state_reducer.dart';
import 'package:FlutterCloudMusic/redux/reducers/theme_data_reducer.dart';
import 'package:FlutterCloudMusic/util/downloader.dart';
import 'package:FlutterCloudMusic/util/navigation.dart';
import 'package:FlutterCloudMusic/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:redux/redux.dart';
import 'discover/discover_page.dart';
import 'model/account.dart';
import 'model/play_songs_model.dart';
import 'redux/middlewares/account_handler.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Application.shared.init();
  final playsongsModel = PlaySongsModel()..init();
  List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => playsongsModel),
  ];
  if (download) {
    await FlutterDownloader.initialize(debug: debug);
    final downloader = await Downloader()..init();
    final provider = ChangeNotifierProvider(create: (_) => downloader);
    providers.add(provider);
  }
  final app = MyApp();
  final provider = MultiProvider(
    providers: providers,
    child: app,
  );
  runApp(provider);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: AppState(account: Account(), themeData: (Application.shared.sp.getBool(Keys.isDarkTheme) ?? false) ? ThemeData.dark() : ThemeData.light()),
    middleware: createMiddlewares(AccountHandler())
  );

  @override
  Widget build(BuildContext context) {
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
