import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/model/video_model.dart';
import 'package:flutter_bilibili_app/util/view_util.dart';

class ExpandableContent extends StatefulWidget {
  final VideoModel mo;

  const ExpandableContent({Key key, this.mo}) : super(key: key);
  @override
  _ExpandableContentState createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent> with SingleTickerProviderStateMixin{
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  bool _expand = false;
  //管理动画
  AnimationController _controller;
  //生成动画高度的值
  Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _controller.addListener(() {
      //监听动画值的变化

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Column(
        children: [
          _buildTitle(),
          Padding(
            padding: EdgeInsets.only(bottom: 8),
          ),
          _buildInfo(),
          _buildDes(),
        ],
      ),
    );
  }

  _buildTitle() {
    return InkWell(
      onTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(widget.mo.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
          ),
          Padding(padding: EdgeInsets.only(left: 15)),
          Icon(
            _expand?Icons.keyboard_arrow_up_sharp:Icons.keyboard_arrow_down_sharp
          ),
        ],
      ),
    );
  }

  void _toggleExpand() {
    setState(() {
      _expand = !_expand;
      if(_expand){
        _controller.forward();
      }else{
        _controller.reverse();
      }
    });
  }

  _buildInfo() {
    var stytle = TextStyle(fontSize: 12, color: Colors.grey);
    var dateStr = widget.mo.createTime.length > 10?widget.mo.createTime.substring(5, 10):widget.mo.createTime;

    return Row(
      children: [
        ...smallIconText(Icons.ondemand_video, widget.mo.view),
        Padding(padding: EdgeInsets.only(left: 10)),
        ...smallIconText(Icons.list_alt, widget.mo.reply),
        Text("     $dateStr", style: stytle,),
      ],
    );
  }

  _buildDes() {
    var child = _expand?Text(widget.mo.desc, style: TextStyle(fontSize: 12, color: Colors.grey),):null;
    return AnimatedBuilder(
        animation: _controller.view,
        child: child,
        builder: (BuildContext context, Widget child){
          return Align(
            heightFactor: _heightFactor.value,
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 8),
              child: child,
            ),
          );
        },
    );
  }
}

