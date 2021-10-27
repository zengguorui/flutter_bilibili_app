import 'package:flutter_bilibili_app/http/core/hi_net.dart';
import 'package:flutter_bilibili_app/http/request/ranking_request.dart';
import 'package:flutter_bilibili_app/model/ranking_model.dart';

class RankingDao{
  static get(String sort, {int pageIndex = 1, pageSize = 10}) async{
    RankingRequest request = RankingRequest();
    request.add("sort", sort).add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return RankingModel.fromJson(result["data"]);
  }
}