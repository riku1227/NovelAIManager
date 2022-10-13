import 'package:flutter/material.dart';

//アウトラインをボーダーで装飾するコンテナ
class OutlineContainer extends StatelessWidget {
  final Widget? child;
  Color? outlineColor;

  OutlineContainer({super.key, this.child, this.outlineColor});

  @override
  Widget build(BuildContext context) {
    if (outlineColor == null) {
      if (Theme.of(context).brightness == Brightness.dark) {
        outlineColor = Colors.white38;
      } else {
        outlineColor = Colors.black54;
      }
    }
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: outlineColor!,
          )),
      child: child,
    );
  }
}
