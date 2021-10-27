import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/barrage/barrage_input.dart';
import 'package:flutter_bilibili_app/barrage/barrage_switch.dart';
import 'package:flutter_bilibili_app/barrage/hi_barrage.dart';
import 'package:flutter_bilibili_app/barrage/hi_socket.dart';
import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/http/dao/favorite_dao.dart';
import 'package:flutter_bilibili_app/http/dao/like_dao.dart';
import 'package:flutter_bilibili_app/http/dao/video_detail_dao.dart';
import 'package:flutter_bilibili_app/model/video_detail_model.dart';
import 'package:flutter_bilibili_app/model/video_model.dart';
import 'package:flutter_bilibili_app/util/toast.dart';
import 'package:flutter_bilibili_app/util/view_util.dart';
import 'package:flutter_bilibili_app/widget/appbar.dart';
import 'package:flutter_bilibili_app/widget/expandable_content.dart';
import 'package:flutter_bilibili_app/widget/hi_tab.dart';
import 'package:flutter_bilibili_app/widget/navigation_bar.dart';
import 'package:flutter_bilibili_app/widget/video_header.dart';
import 'package:flutter_bilibili_app/widget/video_large_card.dart';
import 'package:flutter_bilibili_app/widget/video_toobar.dart';
import 'package:flutter_bilibili_app/widget/video_view.dart';
import 'package:flutter_overlay/flutter_overlay.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> with TickerProviderStateMixin{

  TabController _tabController;
  List tabs = ["简介", "评论288"];
  VideoDetailMo videoDetailMo;
  VideoModel videoModel;
  List<VideoModel> videoList = [];
  var _barrageKey = GlobalKey<HiBarrageState>();
  bool _inoutShowing = false;

  @override
  void initState() {
    super.initState();
    //黑色状态栏，安卓
    changeStatusBar(color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _tabController = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
    _loadDetail();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: Platform.isIOS,
          context: context,
          child: videoModel.url != null?Column(
            children: [
              //黑色状态栏，ios
              NavigationBar(
                color: Colors.black,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                height: Platform.isIOS?46:0,
              ),
              _buildVideoView(),
              _buildTabNavigation(),
              Flexible(
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDetail(),
                      Container(child: Text("敬请期待"),),
                    ]),
              ),
            ],
          ):Container(),
      )
    );
  }

  _buildVideoView() {
    var model = videoModel;
    return VideoView(
      model.url,
      cover: model.cover,
      overlayUI: videoAppBar(),
      barrageUI: HiBarrage(
        key: _barrageKey,
        vid: model.vid,
        autoPlay: true,
      ),
    );
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            _buildBarrageBtn(),
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(tabs.map<Tab>((name) {
      return Tab(
        text: name,
      );
    }).toList(),
    controller: _tabController,
    );
  }

  _buildDetail() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        ..._buildContents(),
        ..._buildVideoList(),
      ],
    );
  }

  _buildContents() {
    return [
      VideoHeader(owner: videoModel.owner,),
      ExpandableContent(mo: videoModel,),
      VideoToolBar(detailMo: videoDetailMo, videoModel: videoModel, onLike: _doLick, onUnLike: _onUnLick, onFavorite: _onFavorite,),
    ];
  }

  void _loadDetail() async{
    try{
      VideoDetailMo result = await VideoDetailDao.get(videoModel.vid);
      setState(() {
        videoDetailMo = result;
        videoModel = result.videoInfo;
        videoList = result.videoList;
      });
    }on NeedAuth catch (e){
      showWarnToast(e.message);
    }on HiNetError catch (e){
      showWarnToast(e.message);
    }
  }

  //不喜欢
  void _onUnLick() async{
    //to do
  }
  //点赞-取消点赞
  void _doLick() async{
    try {
      var result = await LikeDao.like(videoModel.vid, !videoDetailMo.isLike);
      print(result);
      videoDetailMo.isLike = !videoDetailMo.isLike;
      if (videoDetailMo.isLike) {
        videoModel.like += 1;
      } else {
        videoModel.like -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }
  //收藏
  void _onFavorite() async{
    try{
      var result = await FavoriteDao.favorite(videoModel.vid, !videoDetailMo.isFavorite);

      videoDetailMo.isFavorite = !videoDetailMo.isFavorite;
      if(videoDetailMo.isFavorite){
        videoModel.favorite += 1;
      }else{
        videoModel.favorite -= 1;
      }
      setState(() {
        videoModel = videoModel;
        videoDetailMo = videoDetailMo;
      });
      showToast(result["msg"]);
    }on NeedAuth catch (e){
      showWarnToast(e.message);
    }on HiNetError catch (e){
      showWarnToast(e.message);
    }
  }

  _buildVideoList() {
    return videoList.map((VideoModel model) => VideoLargeCard(videoModel: model)).toList();
  }

  _buildBarrageBtn() {
    return BarrageSwitch(
        inoutShowing: _inoutShowing,
        onShowInput: (){
          setState(() {
            _inoutShowing = true;
          });

          HiOverlay.show(context, child: BarrageInput(
              onTabClose: (){
                setState(() {
                  _inoutShowing = false;
                });
              }
          ),
          ).then((value) {
            if(value == null)return;
            print("---input:$value");
            _barrageKey.currentState.send(value);
          });

        },
        onBarrageSwitch: (open){
          if(open){
            _barrageKey.currentState.play();
          }else{
            _barrageKey.currentState.pause();
          }
        }
    );
  }
}