import 'package:flutter_bilibili_app/http/core/hi_net.dart';
import 'package:flutter_bilibili_app/http/request/video_detail_request.dart';
import 'package:flutter_bilibili_app/model/video_detail_model.dart';

///详情页Dao
class VideoDetailDao {
  //https://api.devio.org/uapi/fa/detail/BV19C4y1s7Ka
  static get(String vid) async {
    VideoDetailRequest request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);

    return VideoDetailMo.fromJson(result['data']);
  }
}
