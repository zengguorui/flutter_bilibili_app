import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/db/hi_cache.dart';
import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/http/core/hi_net.dart';
import 'package:flutter_bilibili_app/http/dao/login_dao.dart';
import 'package:flutter_bilibili_app/model/video_model.dart';
import 'package:flutter_bilibili_app/navigator/bottom_navigator.dart';
import 'package:flutter_bilibili_app/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_app/page/dark_mode_page.dart';
import 'package:flutter_bilibili_app/page/login_page.dart';
import 'package:flutter_bilibili_app/page/notice_page.dart';
import 'package:flutter_bilibili_app/page/registration_page.dart';
import 'package:flutter_bilibili_app/page/video_detail_page.dart';
import 'package:flutter_bilibili_app/provider/hi_provider.dart';
import 'package:flutter_bilibili_app/provider/theme_provider.dart';
import 'package:flutter_bilibili_app/util/color.dart';
import 'package:flutter_bilibili_app/util/toast.dart';
import 'package:provider/provider.dart';

//var result = await LoginDao.registration("misszeng", "zeng123456", "7587899", "7807");

void main() {
  runApp(BiliApp());
}

class BiliApp extends StatefulWidget {
  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot){
          //定义route
          var widget = snapshot.connectionState == ConnectionState.done?
          Router(routerDelegate: _routeDelegate):
          Scaffold(body: Center(child: CircularProgressIndicator(),),);

          return MultiProvider( 
              providers: topProviders,
            child: Consumer<ThemeProvider>(
              builder: (BuildContext context, ThemeProvider themeProvider, Widget child){
                return MaterialApp(
                  home: widget,
                  theme: themeProvider.getTheme(),
                  darkTheme: themeProvider.getTheme(isDarkMode: true),
                  themeMode: themeProvider.getThemeMode(),
                );
              },
            ),
          );
        }
    );
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath>{
  final GlobalKey<NavigatorState> navigatorKey;

  BiliRouteDelegate():navigatorKey = GlobalKey<NavigatorState>(){
    //实现路由跳转逻辑
    HiNavigator.getInstance().registerRouteJump(RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map args}){
      _routeStatus = routeStatus;
      if(routeStatus == RouteStatus.detail){
        this.videoModel = args["videoModel"];
      }else{
        this.videoModel = null;
      }
      notifyListeners();
    }));

    //设置网络错误拦截器
    HiNet.getInstance().setErrorInterceptor((error) {
      if (error is NeedLogin) {
        //清空失效的登录令牌
        HiCache.getInstance().setString(LoginDao.BOARDING_PASS, null);
        //拉起登录
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }
    });

  }


  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel videoModel;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage>tempPages = pages;
    if(index != -1){
      tempPages = tempPages.sublist(0, index);
    }

    var page;
    if(routeStatus == RouteStatus.home){
      //跳转首页时将其他页面进行出栈，因为首页不可回避
      pages.clear();
      page = pageWrap(BottomNavigator());
    }else if(routeStatus == RouteStatus.detail){
      page = pageWrap(VideoDetailPage(videoModel));
    }else if(routeStatus == RouteStatus.registration){
      page = pageWrap(RegistrationPage());
    }else if(routeStatus == RouteStatus.login){
      page = pageWrap(LoginPage());
    }else if(routeStatus == RouteStatus.notice){
      page = pageWrap(NoticePage());
    }else if(routeStatus == RouteStatus.darkMode){
      page = pageWrap(DarkModePage());
    }

    //重新创建一个数组，否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];

    //通知路由界面变化
    HiNavigator.getInstance().notify(tempPages, pages);

    pages = tempPages;
    return WillPopScope(
        child: Navigator(
                key: navigatorKey,
                pages: pages,
                onPopPage: (route, result){

                  if(route.settings is MaterialPage){
                    //登录页未登录返回拦截
                    if(!hasLogin){
                      showWarnToast("请先登录");
                      return false;
                    }
                  }
                  //执行返回操作
                  if(!route.didPop(result)){
                    return false;
                  }
                  var tempPages = [...pages];
                  pages.removeLast();
                  //通知路由界面变化
                  HiNavigator.getInstance().notify(pages, tempPages);
                  return true;
                },
              ),
        //fix Android物理返回键，无法返回上一页问题
        onWillPop: () async => !await navigatorKey.currentState.maybePop(),
    );
  }

  RouteStatus get routeStatus {
    if(_routeStatus != RouteStatus.registration && !hasLogin){
      return _routeStatus = RouteStatus.login;
    }else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoradingPass() != null;

  @override
  Future<void> setNewRoutePath(BiliRoutePath configuration) async{}

}

//定义路由数据，path
class BiliRoutePath{
  final String location;

  BiliRoutePath.home():location = "/";
  BiliRoutePath.detail():location = "/detail";

}
