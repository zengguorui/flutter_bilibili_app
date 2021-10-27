import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/core/hi_base_tab_state.dart';
import 'package:flutter_bilibili_app/http/dao/favorite_dao.dart';
import 'package:flutter_bilibili_app/model/ranking_model.dart';
import 'package:flutter_bilibili_app/model/video_model.dart';
import 'package:flutter_bilibili_app/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_app/page/video_detail_page.dart';
import 'package:flutter_bilibili_app/util/view_util.dart';
import 'package:flutter_bilibili_app/widget/navigation_bar.dart';
import 'package:flutter_bilibili_app/widget/video_large_card.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends HiBaseTabState<RankingModel, VideoModel, FavoritePage> {
  RouteChangeListener listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      if (pre?.page is VideoDetailPage) {
        loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildNavigationBar(), Expanded(child: super.build(context))],
    );
  }

  _buildNavigationBar() {
    return NavigationBar(
      child: Container(
        decoration: bottomBoxShadow(context),
        alignment: Alignment.center,
        child: Text('收藏', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    super.dispose();
  }

  @override
  // TODO: implement contentChild
  get contentChild => ListView.builder(
    padding: EdgeInsets.only(top: 10),
    itemCount: dataList.length,
    controller: scrollController,
    physics: const AlwaysScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) =>
        VideoLargeCard(videoModel: dataList[index]),
  );

  @override
  Future<RankingModel> getDada(int pageIndex) async{
    RankingModel result =
        await FavoriteDao.favoriteList(pageIndex: pageIndex, pageSize: 20);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingModel result) {
    return result.list;
  }

}
