import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/http/dao/profile_dao.dart';
import 'package:flutter_bilibili_app/model/profile_model.dart';
import 'package:flutter_bilibili_app/util/toast.dart';
import 'package:flutter_bilibili_app/util/view_util.dart';
import 'package:flutter_bilibili_app/widget/benefit_card.dart';
import 'package:flutter_bilibili_app/widget/course_card.dart';
import 'package:flutter_bilibili_app/widget/dark_mode_item.dart';
import 'package:flutter_bilibili_app/widget/hi_banner.dart';
import 'package:flutter_bilibili_app/widget/hi_blur.dart';
import 'package:flutter_bilibili_app/widget/hi_flexible_header.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin{

  ProfileModel _profileModel;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return <Widget>[
            _buildAppBar(),
          ];
        },
        body: ListView(
          padding: EdgeInsets.only(top: 10),
          children: [
            ..._buildContextList(),
          ],
        ),
      ),
    );
  }

  void _loadData() async{
    try{
      ProfileModel result = await ProfileDao.get();
      setState(() {
        _profileModel = result;
      });
    }on NeedAuth catch (e){
      showWarnToast(e.message);
    }on HiNetError catch (e){
      showWarnToast(e.message);
    }
  }

  _buildHead() {
    if(_profileModel == null){
      return Container();
    }else{
      return HiFlexibleHeader(name: _profileModel.name, face: _profileModel.face, controller: _controller);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _buildAppBar() {
    return SliverAppBar(
      //扩展高度
      expandedHeight: 160,
      //标题栏是否固定
      pinned: true,
      //定义滚动空间
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.only(left: 0),
        title: _buildHead(),
        background: Stack(
          children: [
            Positioned.fill(
                child: cachedImage(
                    'https://www.devio.org/img/beauty_camera/beauty_camera4.jpg')),
            Positioned.fill(child: HiBlur(sigma: 20)),
            Positioned(bottom: 0, left: 0, right: 0, child: _buildProfileTab())
          ],
        ),
      ),
    );
  }

  _buildContextList() {
    if(_profileModel == null)return [];
    return [
      _buildBanner(),
      CourseCard(courseList: _profileModel.courseList,),
      BenefitCard(benefitList: _profileModel.benefitList,),
      DarkModeItem()
    ];
  }

  _buildBanner() {
    return HiBanner(_profileModel.bannerList, bannerHeight: 120, padding: EdgeInsets.only(left: 10, right: 10),);
  }

  _buildProfileTab() {
    if(_profileModel == null) return Container();
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white54
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText("收藏", _profileModel.favorite),
          _buildIconText("点赞", _profileModel.like),
          _buildIconText("浏览", _profileModel.browsing),
          _buildIconText("金币", _profileModel.coin),
          _buildIconText("粉丝", _profileModel.fans),
        ],
      ),
    );
  }

  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text("$count", style: TextStyle(fontSize: 15, color: Colors.black87),),
        Text("$text", style: TextStyle(fontSize: 12, color: Colors.grey),),
      ],
    );
  }
}
