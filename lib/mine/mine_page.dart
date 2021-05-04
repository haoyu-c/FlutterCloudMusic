import 'package:FlutterCloudMusic/dowload/download_page.dart';
import 'package:FlutterCloudMusic/entrance/application.dart';
import 'package:FlutterCloudMusic/entrance/splash_page.dart';
import 'package:FlutterCloudMusic/model/user.dart';
import 'package:FlutterCloudMusic/redux/actions.dart';
import 'package:FlutterCloudMusic/util/constants.dart';
import 'package:FlutterCloudMusic/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: appBar,
        body: listView
      ),
      onWillPop: () async => true,
    );
  }

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = AppState.storeOf(context);
      if (store.state.account.token != null) {
        store.dispatch(GetUserInfoAction(userId: store.state.account.token.user.id));
      }
    });
  }


  get listView {
    final listView = ListView.builder(itemBuilder: (context, index) {
      Widget cell;
      if (index == 0) {
        cell = header;
      } else if (index > 0 && index < 2) {
        cell = appearanceSetting("夜间模式", () => null);
      } else if (index == 2) {
        cell = downloadSetting;
      } else {
        cell = logout;
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          cell,
          Divider(
            color: themeData.separatorColor,
            height: 1,
            indent: 32,
          )
        ],
      );
    },
      itemCount: 4,
      shrinkWrap: true,
    );
    return Container(
      color: themeData.systemGroupedBackgroundColor,
      width: 1.sw,
      height: 1.sh,
      child: listView,
    );
  }

  appearanceSetting(String title, Function() callback) {
    final detector = GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          20.w,
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CMText(text: title, fontSize: 17)
          ),
          Spacer(),
          CupertinoSwitch(value: !appState.themeData.isLight, onChanged: (isDark) {
            store.dispatch(isDark ? DarkThemeAction() : LightThemeAction());
            setState(() { });
            Keys.tabKey.currentState.setState(() {});
          }),
          20.w
        ],
      ),
    );
    return Container(
      color: themeData.secondarySystemGroupedBackgroundColor,
      child: detector,
    );
  }

  Widget get downloadSetting  {
    final detector = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return DownloadPage();
        }));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          20.w,
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CMText(text: "下载管理", fontSize: 17)
          ),
          Spacer(),
        ],
      ),
    );
    return Container(
      color: themeData.secondarySystemGroupedBackgroundColor,
      child: detector,
    );
  }

  get logout {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        AppState.storeOf(context).dispatch(LogoutAction());
        defaultNavigator.popUntil((route) => route.isFirst);
        Keys.splashKey.currentState.startAnimation();
      },
      child: Container(
        height: 50,
        width: 1.sw,
        color: themeData.secondarySystemGroupedBackgroundColor,
        child: Center(
          child: CMText(text: "退出登陆", color: ColorComponent.red, fontSize: 17,)
        ),
      ),
    );
  }

  get header {
    final header = StoreConnector<AppState, User>(
      builder: (context, user) {
        return Column(
          children: [
            25.h,
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                20.w,
                ClipOval(
                  child: (user == null) ? 
                    Container(color: Colors.grey, width: 60, height: 60) :
                    CachedNetworkImage(imageUrl: user.avatarUrl, width: 60,height: 60,)
                ),
                10.w,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CMText(text: user == null ? "": user.username, fontSize: 18),
                      CMText(text: "这个人很懒，没有填写个性签名", fontSize: 18)
                    ]
                  )
                ),
                10.w,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorComponent.red),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: 80,
                  height: 30,
                  child: Center(
                    child: CMText(
                      text: "签到",
                      color: ColorComponent.red,
                      fontSize: 15,
                    ),
                  ),
                ),
                20.w
              ],
            ),
            25.h
          ],
        );
      }, 
      converter: (store) => store.state.account.user,
      distinct: true,
    );
    return Container(
      color: themeData.secondarySystemGroupedBackgroundColor,
      child: header,
    );
  }

  get appBar {
    return AppBar(
      title: CMText(text: "账号"),
      automaticallyImplyLeading: false,
      backgroundColor: blackWhiteBg,
      elevation: 0,
      brightness: ThemeDataExtension.appBar(context),
      bottom: PreferredSize(
        child: Container(
          color: themeData.separatorColor,
          height: 1.0,
        ),
        preferredSize: Size.fromHeight(4.0)),
    );
  }
}
