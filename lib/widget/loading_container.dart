import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  //加载动画是否覆盖在原有界面上
  final bool cover;

  const LoadingContainer({Key key, this.isLoading, this.child, this.cover = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(cover){
      return Stack(
        children: [
          child,
          isLoading?_loadingView:Container()
        ],
      );
    }else{
      return isLoading?_loadingView:child;
    }
  }

  //lottie动画
  Widget get _loadingView{
    return Center(child: Lottie.asset("assets/loading.json"),);
  }
}
