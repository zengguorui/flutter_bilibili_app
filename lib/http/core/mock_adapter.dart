
import 'package:flutter_bilibili_app/http/core/hi_net_adapter.dart';
import 'package:flutter_bilibili_app/http/request/hi_base_request.dart';

//测试适配器，mock数据
class MockAdapter extends HiNetAdapter{
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) {
    // TODO: implement send
    return Future<HiNetResponse>.delayed(Duration(milliseconds: 1000), (){
      return HiNetResponse(data: {"code":0, "message":"success"}, statusCode: 200, statusMessage: "请求成功");
    });
  }

}