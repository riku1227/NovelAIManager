import 'package:flutter/material.dart';
import 'package:novelai_manager/components/widget/long_press_icon_button.dart';
import 'package:novelai_manager/util/general_util.dart';

/// コピーボタンが横にあるテキストフィールド
/// タップ時/長押し時の動作を変えることも可能
class CopyTextField extends StatelessWidget {
  // テキストフィールド
  final TextField textField;
  // タップ / クリックしたとき
  final Function(String text)? onTap;
  // 長押ししたとき
  final Function(String text)? onLongPress;

  const CopyTextField({
    super.key,
    required this.textField,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: textField,
        ),
        const SizedBox(width: 4),
        LongPressIconButton(
          icon: const Icon(Icons.copy),
          onTap: () {
            if (textField.controller == null) {
              return;
            }

            // onTapが設定されている場合はその処理を呼び出して終わる
            if (onTap != null) {
              onTap!(textField.controller!.text);
              return;
            }

            GeneralUtil.copyToClipboard(context, textField.controller!.text);
          },
          onLongPress: () {
            if (textField.controller == null) {
              return;
            }
            if (onLongPress != null) {
              onLongPress!(textField.controller!.text);
            }
          },
        ),
      ],
    );
  }
}
