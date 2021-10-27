import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/core/hi_base_tab_state.dart';
import 'package:flutter_bilibili_app/http/core/hi_error.dart';
import 'package:flutter_bilibili_app/http/dao/home_dao.dart';
import 'package:flutter_bilibili_app/model/home_model.dart';
import 'package:flutter_bilibili_app/model/video_model.dart';
import 'package:flutter_bilibili_app/util/color.dart';
import 'package:flutter_bilibili_app/util/toast.dart';
import 'package:flutter_bilibili_app/widget/hi_banner.dart';
import 'package:flutter_bilibili_app/widget/video_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo> bannerList;

  const HomeTabPage({Key key, this.categoryName, this.bannerList}) : super(key: key);
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends HiBaseTabState<HomeModel, VideoModel, HomeTabPage> {

  @override
  void initState() {
    super.initState();
  }

  _banner() {
    return HiBanner(widget.bannerList, padding: EdgeInsets.only(left: 5, right: 5),);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // TODO: implement contentChild
  get contentChild => StaggeredGridView.countBuilder(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      crossAxisCount: 2,
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index){
        if(widget.bannerList != null && index ==0){
          return Padding(padding: EdgeInsets.only(bottom: 8), child: _banner(),);
        }else{
          return VideoCard(videoMo: dataList[index],);
        }
      },
      staggeredTileBuilder: (int index){
        if(widget.bannerList != null && index == 0){
          return StaggeredTile.fit(2);
        }else{
          return StaggeredTile.fit(1);
        }
      }
  );

  @override
  Future<HomeModel> getDada(int pageIndex) async{
    HomeModel result = await HomeDao.get(widget.categoryName, pageIndex: pageIndex, pageSize: 30);
    return result;
  }

  @override
  List<VideoModel> parseList(HomeModel result) {
    return result.videoList;
  }
}
