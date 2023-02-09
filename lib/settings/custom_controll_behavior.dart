import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// スクロールジェスチャーのデバイス設定
/// マウスでもスクロールできるようにする
class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
