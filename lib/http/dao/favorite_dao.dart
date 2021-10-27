import 'package:flutter_bilibili_app/http/core/hi_net.dart';
import 'package:flutter_bilibili_app/http/request/hi_base_request.dart';
import 'package:flutter_bilibili_app/http/request/cancel_favorite_request.dart';
import 'package:flutter_bilibili_app/http/request/favorite_list_request.dart';
import 'package:flutter_bilibili_app/http/request/favorite_request.dart';
import 'package:flutter_bilibili_app/model/ranking_model.dart';

class FavoriteDao {
  // https://api.devio.org/uapi/fa/favorite/BV1qt411j7fV
  static favorite(String vid, bool favorite) async {
    HiBaseRequest request =
    favorite ? FavoriteRequest() : CancelFavoriteRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

  static favoriteList({int pageIndex = 1, int pageSize = 10}) async {
    FavoriteListRequest request = FavoriteListRequest();
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return RankingModel.fromJson(result['data']);
  }
}