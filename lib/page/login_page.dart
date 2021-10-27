import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_app/util/toast.dart';
import 'package:flutter_bilibili_app/widget/appbar.dart';
import 'package:flutter_bilibili_app/widget/login_button.dart';
import 'package:flutter_bilibili_app/widget/login_effect.dart';
import 'package:flutter_bilibili_app/widget/login_input.dart';
import 'package:flutter_bilibili_app/util/string_util.dart';
import 'package:flutter_bilibili_app/http/dao/login_dao.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  String userName;
  String password;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("密码登录", "注册", (){
        HiNavigator.getInstance().onJumpTo((RouteStatus.registration));
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect,),
            LoginInput(
              "用户名",
              "请输入用户名",
              onChanged: (e){
                userName = e;
                checkInput();
              },
            ),
            LoginInput(
              "密码",
              "请输入密码",
              obscureText: true,
              lineStrech: true,
              onChanged: (e){
                password = e;
                checkInput();
              },
              focusChanged: (focus){
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            Padding(padding: EdgeInsets.only(top: 20, left: 20, right: 20,),
              child: LoginButton(title: "登录", enable: loginEnable, onPressed: send,),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if(isNotEmpty(userName)  && isNotEmpty(password)){
      enable = true;
    }else{
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async{
    try {
      var result = await LoginDao.login(userName, password);

      if(result["code"] == 0){
        showToast("登录成功");
        HiNavigator.getInstance().onJumpTo((RouteStatus.home));
      }else{
        showWarnToast(result["msg"]);
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }
}
