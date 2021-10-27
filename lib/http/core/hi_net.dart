import 'package:flutter_bilibili_app/http/core/dio.adapter.dart';
import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/http/core/hi_interceptor.dart';
import 'package:flutter_bilibili_app/http/core/hi_net_adapter.dart';
import 'package:flutter_bilibili_app/http/request/hi_base_request.dart';

class HiNet{
  HiNet._();

  HiErrorInterceptor _hiErrorInterceptor;

  static HiNet _instance;
  static HiNet getInstance(){
    if(_instance == null){
      _instance = HiNet._();
    }

    return _instance;
  }

  Future fire(HiBaseRequest request) async{
    HiNetResponse response;
    var error;
    try{
      response = await send(request);
    } on HiNetError catch(e){
      error = e;
      response = e.data;
      printLog(e.message);
    } catch(e){
      //其它异常
      error = e;
      printLog(e);
    }

    if(response == null){
      printLog(error);
    }

    var result = response.data;
    printLog(result);

    var status = response.statusCode;
    var hiError;

    switch(status){
      case 200:
        return result;
        break;
      case 401:
        hiError = NeedLogin();
        break;
      case 403:
        hiError = NeedAuth(result.toString(), data: result);
        break;
      default:
        hiError = HiNetError(status, result.toString(), data: result);
        break;
    }

    //交给拦截器处理错误
    if (_hiErrorInterceptor != null) {
      _hiErrorInterceptor(hiError);
    }
    throw hiError;
  }

  Future<dynamic>send<T>(HiBaseRequest request) async{
  //使用mock发送请求
//    HiNetAdapter adapter = MockAdapter();
    //使用dio发送请求
    HiNetAdapter adapter = DioAdapter();
    printLog("url:${request.url()}");
    printLog("method:${request.httpMethod()}");
    printLog("header:${request.header}");

    return adapter.send(request);
  }

  void setErrorInterceptor(HiErrorInterceptor interceptor) {
    this._hiErrorInterceptor = interceptor;
  }

  void printLog(log){
    print("hi_net:${log.toString()}");
  }
}