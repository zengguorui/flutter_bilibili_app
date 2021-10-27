import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/barrage/barrage_transition.dart';

///弹幕widget
class BarrageItem extends StatelessWidget {

  final String id;
  final double top;
  final Widget child;
  final ValueChanged onComplete;
  final Duration duration;

  BarrageItem({Key key, this.id, this.top, this.onComplete, this.duration = const Duration(milliseconds: 9000), this.child}) : super(key: key);

  //fix 动画状态错乱
  var _key = GlobalKey<BarrageTransitionState>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: top,
        child: BarrageTransition(
          key: _key,
          child: child,
          onComplete: (v){
            onComplete(id);
          },
          duration: duration,
        ),
    );
  }
}
