import 'package:FlutterCloudMusic/component/cmtextformfield.dart';
import 'package:FlutterCloudMusic/login/register_info.dart';
import 'package:FlutterCloudMusic/login/token.dart';
import 'package:FlutterCloudMusic/network/Result.dart';
import 'package:FlutterCloudMusic/network/network.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:FlutterCloudMusic/util/constants.dart';
import 'package:FlutterCloudMusic/util/validator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  String _email = "";

  @override
  Widget build(BuildContext context) {
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logo(),
        SizedBox(height: 30),
        emailTextField(),
        SizedBox(height: 10),
        usernameTextField(),
        SizedBox(height: 10),
        passwordTextField(),
        SizedBox(height: 10),
        comfirmPasswordTextField(),
        SizedBox(height: 10),
        registerButton()
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

  Widget emailTextField() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      child: CMTextFormField(
        prefixIcon: Icon(Icons.email, color: Colors.black),
        hintText: "邮箱",
        validator: (String email) {
          return email.isValidEmail() ? null : "邮箱格式不正确";
        },
        onSaved: (String email) {
          _email = email;
        },
      ),
    );
  }

  Widget usernameTextField() {
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
          return (password.length < 6) ? "密码少于六位数" : null;
        },
        onChanged: (String password) {
          _password = password;
        },
        onSaved: (String password) {
          _password = password;
        },
      ),
    );
  }

  Widget comfirmPasswordTextField() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      child: CMTextFormField(
        obscureText: true,
        prefixIcon: Icon(Icons.lock, color: Colors.black),
        hintText: "确认密码",
        validator: (String confirmPassword) {
          return confirmPassword == _password ? null : "两次密码输入不一致";
        },
      ),
    );
  }

  Widget registerButton() {
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
                  text: "注册",
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
      performRegister().then((result) {
        final snackBarContent = (result.isSuccess)
            ? "注册成功"
            : NetworkErrorInfo.fromError(result.error).reason;
        final scaffold = Scaffold.of(context);
        scaffold.showSnackBar(SnackBar(
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

  Future<Result<Token, DioError>> performRegister() async {
    isLoading = true;
    try {
      final infoData =
          RegisterInfo(username: _username, password: _password, email: _email)
              .toMap();
      final response = await (await dio).post('api/users/signup', data: infoData);
      isLoading = false;
      return Result.success(Token.fromMap(response.data));
    } on DioError catch (error) {
      isLoading = false;
      return Result.error(error);
    }
  }
}
