import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// SingleChildScrollViewをラップしたスクロールビュー
/// Flutterはマウスでのスクロール感度が低いのでそれ対策用
class MyScrollView extends StatelessWidget {
  final Widget child;
  final ScrollController _scrollController = ScrollController();

  MyScrollView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    //ポインターのイベントを受け取る
    return Listener(
      onPointerSignal: (event) async {
        //スクロールイベントだったら
        if (event is PointerScrollEvent) {
          /// スクロール先のポジション
          /// このイベントが届いた時点でoffsetはスクロール後の位置になっている
          /// それに追加でスクロール(移動)させる (現状だと倍の感度)
          var scrollPosition = _scrollController.offset + event.scrollDelta.dy;

          ///スクロール範囲以上にスクロールできないようにする
          if (_scrollController.position.maxScrollExtent < scrollPosition) {
            scrollPosition = _scrollController.position.maxScrollExtent;
          } else if (_scrollController.position.minScrollExtent >
              scrollPosition) {
            scrollPosition = _scrollController.position.minScrollExtent;
          }

          _scrollController.jumpTo(scrollPosition);
        }
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: child,
      ),
    );
  }
}
