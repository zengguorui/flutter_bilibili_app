import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/model/video_model.dart';
import 'package:flutter_bilibili_app/util/color.dart';
import 'package:flutter_bilibili_app/util/format_util.dart';
import 'package:flutter_bilibili_app/util/view_util.dart';

class VideoHeader extends StatelessWidget {
  final Owner owner;

  const VideoHeader({Key key, this.owner}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: cachedImage(owner.face, width: 30, height: 30),
              ),
              Padding(padding: EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    Text(owner.name, style: TextStyle(fontSize: 13, color: primary, fontWeight: FontWeight.bold),),
                    Text("${countFormat(owner.fans)}粉丝", style: TextStyle(fontSize: 10, color: Colors.grey),),
                  ],
                ),
              ),
            ],
          ),
          MaterialButton(
            onPressed: (){
              print("----关注----");
              },
            color: primary,
            height: 24,
            minWidth: 50,
            child: Text(" + 关注", style: TextStyle(fontSize: 13, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
