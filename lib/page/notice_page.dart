import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/core/hi_base_tab_state.dart';
import 'package:flutter_bilibili_app/http/dao/notice_dao.dart';
import 'package:flutter_bilibili_app/model/home_model.dart';
import 'package:flutter_bilibili_app/model/notice_model.dart';
import 'package:flutter_bilibili_app/widget/notice_card.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends HiBaseTabState<NoticeModel, BannerMo , NoticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [_buildNavigationBar(), Expanded(child: super.build(context))],
        ));
  }

  _buildNavigationBar() {
    return AppBar(
      title: Text('通知'),
    );
  }

  @override
  get contentChild => ListView.builder(
    padding: EdgeInsets.only(top: 10),
    itemCount: dataList.length,
    controller: scrollController,
    physics: const AlwaysScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) =>
        NoticeCard(bannerMo: dataList[index]),
  );

  @override
  Future<NoticeModel> getDada(int pageIndex) async {
    NoticeModel result =
    await NoticeDao.noticeList(pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<BannerMo> parseList(NoticeModel result) {
    return result.list;
  }
}
