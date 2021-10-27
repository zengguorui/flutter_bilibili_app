import 'package:flutter_bilibili_app/http/request/hi_base_request.dart';
import 'package:flutter_bilibili_app/http/request/favorite_request.dart';

class CancelFavoriteRequest extends FavoriteRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.DELETE;
  }
}