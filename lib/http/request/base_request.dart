import 'package:flutter_bilibili_app/http/dao/login_dao.dart';
import 'package:flutter_bilibili_app/http/request/hi_base_request.dart';
import 'package:flutter_bilibili_app/util/hi_constants.dart';

abstract class BaseRequest extends HiBaseRequest{
  @override
  String url() {
    if(needLogin()){
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoradingPass());
    }
    return super.url();
  }

  Map<String, dynamic> header = {//6D97F324CC616CDEA2D1F40DFDFD82F4AF
    HiConstants.authTokenK:HiConstants.authTokenV,
    HiConstants.courseFlagK:HiConstants.courseFlagV,
  };
}