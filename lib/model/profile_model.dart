import 'package:flutter_bilibili_app/model/home_model.dart';

///个人中心Mo
class ProfileModel {
  String name;
  String face;
  int fans;
  int favorite;
  int like;
  int coin;
  int browsing;
  List<BannerMo> bannerList;
  List<Course> courseList;
  List<Benefit> benefitList;

  ProfileModel(
      {this.name,
        this.face,
        this.fans,
        this.favorite,
        this.like,
        this.coin,
        this.browsing,
        this.bannerList,
        this.courseList,
        this.benefitList});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    face = json['face'];
    fans = json['fans'];
    favorite = json['favorite'];
    like = json['like'];
    coin = json['coin'];
    browsing = json['browsing'];
    if (json['bannerList'] != null) {
      bannerList = new List<BannerMo>.empty(growable: true);
      json['bannerList'].forEach((v) {
        bannerList.add(new BannerMo.fromJson(v));
      });
    }
    if (json['courseList'] != null) {
      courseList = new List<Course>();
      json['courseList'].forEach((v) {
        courseList.add(new Course.fromJson(v));
      });
    }
    if (json['benefitList'] != null) {
      benefitList = new List<Benefit>.empty(growable: true);
      json['benefitList'].forEach((v) {
        benefitList.add(new Benefit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['face'] = this.face;
    data['fans'] = this.fans;
    data['favorite'] = this.favorite;
    data['like'] = this.like;
    data['coin'] = this.coin;
    data['browsing'] = this.browsing;
    if (this.bannerList != null) {
      data['bannerList'] = this.bannerList.map((v) => v.toJson()).toList();
    }
    if (this.courseList != null) {
      data['courseList'] = this.courseList.map((v) => v.toJson()).toList();
    }
    if (this.benefitList != null) {
      data['benefitList'] = this.benefitList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Course {
  String name;
  String cover;
  String url;
  int group;

  Course({this.name, this.cover, this.url, this.group});

  Course.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cover = json['cover'];
    url = json['url'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['cover'] = this.cover;
    data['url'] = this.url;
    data['group'] = this.group;
    return data;
  }
}

class Benefit {
  String name;
  String url;

  Benefit({this.name, this.url});

  Benefit.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}