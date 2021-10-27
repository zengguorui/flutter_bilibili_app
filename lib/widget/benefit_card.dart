import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/model/profile_model.dart';
import 'package:flutter_bilibili_app/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_app/util/toast.dart';
import 'package:flutter_bilibili_app/util/view_util.dart';
import 'package:flutter_bilibili_app/widget/hi_blur.dart';

///增值服务
class BenefitCard extends StatelessWidget {
  final List<Benefit> benefitList;

  const BenefitCard({Key key, @required this.benefitList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 5, top: 15),
      child: Column(
        children: [
          _buildTitle(),
          _buildBenefit(context),
        ],
      ),
    );
  }

  _buildTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text("增值服务", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          hiSpace(width: 10),
          Text("购买后登录慕课网再次点击打开查看", style: TextStyle(fontSize: 12, color: Colors.grey[600]),),
        ],
      ),
    );
  }

  _buildCard(BuildContext context, Benefit mo, double width) {
    return InkWell(
      onTap: (){

        if(mo.name == "交流群"){
          FlutterClipboard.copy(mo.url).then(( value ) => showToast("复制群号（${mo.url}）到内存成功！"));
          return;
        }

        if(mo.url != null){
          HiNavigator.getInstance().openH5(mo.url);
        }else{

        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: 5, bottom: 7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            alignment: Alignment.center,
            width: width,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent
            ),
            child: Stack(
              children: [
                Positioned.fill(child: HiBlur()),
                Positioned.fill(child: Center(child: Text(mo.name, style: TextStyle(color: Colors.white54), textAlign: TextAlign.center,),)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildBenefit(BuildContext context) {
    var width = (MediaQuery.of(context).size.width - 20 - (benefitList.length - 1) * 5) / benefitList.length;
    return Row(
      children: [
        ...benefitList.map((e) => _buildCard(context, e, width)).toList()
      ],
    );

  }
}
