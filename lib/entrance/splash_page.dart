import 'package:FlutterCloudMusic/app.dart';
import 'package:FlutterCloudMusic/entrance/application.dart';
import 'package:FlutterCloudMusic/model/app_state.dart';
import 'package:FlutterCloudMusic/redux/actions.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';
import 'package:FlutterCloudMusic/util/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:redux/redux.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}): super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with TickerProviderStateMixin {

  Tween _scaleTween;
  AnimationController _logoController;
  CurvedAnimation _logoAnimation;
  Store<AppState> get _store {
    return AppState.storeOf(context);
  }
  AppState get _state {
    return _store.state;
  }

  static SplashPageState of(BuildContext context) {
    return context.findAncestorStateOfType<SplashPageState>();
  }

  @override
  void initState() {
    super.initState();
    // scale 从 0 到 1
    _scaleTween = Tween(begin: 0, end: 1);
    _logoController = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..drive(_scaleTween);
    // 从 0 到 1 的动画曲线
    _logoAnimation = CurvedAnimation(parent: _logoController, curve: Curves.easeOutQuart);
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        Future.delayed(Duration(milliseconds: 1000), () {
          goPage().then((value) {
            _logoController.reverse();
          });
        });
      }
    });
    startAnimation();
  }

  startAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      _logoController.forward();
    });
  }
  
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _store.dispatch(StartLoadAction());
      initialized = true;
    }
  }

  Future goPage() async {
    if (_state.account == null || _state.account.token == null)  {
      defaultNavigator.pushNamed(Routes.welcomePage);
    } else {
      defaultNavigator.pushNamed(Routes.tabPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: 1.sw,
        height: 1.sh,
        child: ScaleTransition(
          scale: _logoAnimation,
          child: Hero(
            tag: 'icon',
            child: CMImage.named('icon', width: 100, height: 100)
          )
        ),
      )
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }
}