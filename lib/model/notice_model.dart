import 'package:flutter_bilibili_app/model/home_model.dart';

class NoticeModel {
  int total;
  List<BannerMo> list;

  NoticeModel({this.total, this.list});

  NoticeModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = new List<BannerMo>.empty(growable: true);
      json['list'].forEach((v) {
        list.add(new BannerMo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}