import 'dart:convert';
import 'dart:async';
import 'package:FlutterCloudMusic/component/cmtextformfield.dart';
import 'package:FlutterCloudMusic/login/token.dart';
import 'package:FlutterCloudMusic/model/app_state.dart';
import 'package:FlutterCloudMusic/network/Result.dart';
import 'package:FlutterCloudMusic/network/network.dart';
import 'package:FlutterCloudMusic/redux/actions.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:FlutterCloudMusic/util/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logo(),
        SizedBox(height: 30),
        loginTextField(),
        SizedBox(height: 10),
        passwordTextField(),
        SizedBox(height: 10),
        loginButton()
      ],
    );
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
            child: Stack(
          children: [
            column,
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(),
          ],
        )),
      ),
    );
  }

  Widget logo() {
    return Image.asset(imageNamed("icon"), width: 60, height: 60);
  }

  Widget loginTextField() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      child: CMTextFormField(
        prefixIcon: Icon(Icons.person, color: Colors.black),
        hintText: "用户名",
        validator: (String username) {
          return username.isEmpty ? "用户名为空" : null;
        },
        onSaved: (String username) {
          _username = username;
        },
        initialValue: "chy",
      ),
    );
  }

  Widget passwordTextField() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      child: CMTextFormField(
        obscureText: true,
        prefixIcon: Icon(Icons.lock, color: Colors.black),
        hintText: "密码",
        validator: (String password) {
          return password.isEmpty ? "密码为空" : null;
        },
        onSaved: (String password) {
          _password = password;
        },
        initialValue: "chypassword",
      ),
    );
  }

  Widget loginButton() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: Builder(
          builder: (context) => ElevatedButton(
              onPressed: () => validateAndSave(context),
              style: ElevatedButton.styleFrom(
                  primary: ColorComponent.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: CMText(
                  text: "登陆",
                  fontName: "PingFangSC-Regular",
                  fontSize: 18,
                  color: Colors.white,
                ),
              )),
        ));
  }

  void validateAndSave(BuildContext context) {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      AppState.storeOf(context).dispatch(LoginAction(context: context, password: _password, username: _username));
      performLogin().then((result) {
        final snackBarContent = (result.isSuccess)
            ? "登陆成功"
            : NetworkErrorInfo.fromError(result.error).reason;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(snackBarContent),
        ));
      });
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool loading) {
    setState(() {
      this._isLoading = loading;
    });
  }

  Future<Result<Token, DioError>> performLogin() async {
    isLoading = true;
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    try {
      final response = await (await dioFuture).post('api/users/login',
          options:
              Options(headers: <String, String>{'authorization': basicAuth}));
      isLoading = false;
      return Result.success(Token.fromMap(response.data));
    } on DioError catch (error) {
      isLoading = false;
      return Result.error(error);
    }
  }
}
