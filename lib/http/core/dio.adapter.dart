//dio适配器
import 'package:dio/dio.dart';
import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/http/core/hi_net_adapter.dart';
import 'package:flutter_bilibili_app/http/request/hi_base_request.dart';

class DioAdapter extends HiNetAdapter{
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) async {
    var response, options = Options(headers: request.header);
    var error;
    try{
      switch(request.httpMethod()){
        case HttpMethod.GET:
          response = await Dio().get(request.url(), options: options);
          break;
        case HttpMethod.POST:
          response = await Dio().post(request.url(), data: request.params, options: options);
          break;
        case HttpMethod.DELETE:
          response = await Dio().delete(request.url(), data: request.params, options: options);
          break;
      }
    }on DioError catch(e){
      error = e;
      response = e.response;
    }
    
    if(error == null){
      //抛出异常
      throw HiNetError(response?.statusCode ?? -1, error.toString(), data: buildRes(response, request));
    }
    return buildRes(response, request);
  }

//  构建HiNetResponse
  HiNetResponse buildRes(Response response, HiBaseRequest request) {
    return HiNetResponse(
      data: response.data,
      request: request,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response
    );
  }
}