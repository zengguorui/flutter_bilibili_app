import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/http/dao/login_dao.dart';
import 'package:flutter_bilibili_app/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_app/util/string_util.dart';
import 'package:flutter_bilibili_app/util/toast.dart';
import 'package:flutter_bilibili_app/widget/appbar.dart';
import 'package:flutter_bilibili_app/widget/login_button.dart';
import 'package:flutter_bilibili_app/widget/login_effect.dart';
import 'package:flutter_bilibili_app/widget/login_input.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key key}) : super(key: key);
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  String userName;
  String password;
  String rePaaword;
  String imoocId;
  String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", (){
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
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
            LoginInput(
              "确认密码",
              "请再次输入密码",
              obscureText: true,
              lineStrech: true,
              onChanged: (e){
                rePaaword = e;
                checkInput();
              },
              focusChanged: (focus){
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              "慕课网ID",
              "请输入慕课网ID",
              keyboardType: TextInputType.number,
              onChanged: (e){
                imoocId = e;
                checkInput();
              },
            ),
            LoginInput(
              "课程订单号",
              "请输入课程订单号后四位",
              keyboardType: TextInputType.number,
              onChanged: (e){
                orderId = e;
                checkInput();
              },
            ),
            Padding(padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(title: "注册", enable: loginEnable, onPressed: checkParams,),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if(isNotEmpty(userName)  && isNotEmpty(password) && isNotEmpty(rePaaword) && isNotEmpty(imoocId) && isNotEmpty(orderId)){
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
//      var result = await LoginDao.registration("misszeng", "zeng123456", "7587899", "7807");
      var result = await LoginDao.registration(userName, password, imoocId, orderId);

      if(result["code"] == 0){
        showToast("注册成功");
        HiNavigator.getInstance().onJumpTo((RouteStatus.login));
      }else{
        showWarnToast(result["msg"]);
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  void checkParams() {
    String tips;
    if(password != rePaaword){
      tips = "两次密码不一致";
    }else if (orderId.length != 4){
      tips = "请输入订单号后四位";
    }
    if (tips != null){
      print(tips);
      return;
    }
    send();
  }
}
