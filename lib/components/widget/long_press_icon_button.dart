import 'package:flutter/material.dart';

/// 長押ししたときの処理を設定できるようにしたアイコンボタン
/// 中身はInkWellとただのIcon
class LongPressIconButton extends StatelessWidget {
  //ボタンのアイコン
  final Icon icon;
  //タップ/クリックしたとき
  final Function()? onTap;
  //長押ししたとき
  final Function()? onLongPress;

  const LongPressIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: icon,
      ),
    );
  }
}
