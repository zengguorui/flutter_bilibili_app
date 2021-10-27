import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/core/hi_base_tab_state.dart';
import 'package:flutter_bilibili_app/http/dao/ranking_dao.dart';
import 'package:flutter_bilibili_app/model/ranking_model.dart';
import 'package:flutter_bilibili_app/model/video_model.dart';
import 'package:flutter_bilibili_app/widget/video_large_card.dart';

class RankingTabPage extends StatefulWidget {
  final String sort;

  const RankingTabPage({Key key, @required this.sort}) : super(key: key);
  @override
  _RankingTabPageState createState() => _RankingTabPageState();
}

class _RankingTabPageState extends HiBaseTabState<RankingModel, VideoModel, RankingTabPage> {

  @override
  // TODO: implement contentChild
  get contentChild => Container(
    child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 10),
        itemCount: dataList.length,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index)=>
            VideoLargeCard(videoModel: dataList[index]),
    ),
  );

  @override
  Future<RankingModel> getDada(int pageIndex) async{
    RankingModel result = await RankingDao.get(widget.sort, pageIndex: pageIndex, pageSize: 20);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingModel result) {
    return result.list;
  }
}
