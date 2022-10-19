import 'package:flutter/material.dart';

/// ポジティブボタンとキャンセルボタン(ネガティブボタン)のシンプルなダイアログ
/// ポジティブボタンを押した場合はtrueを返す
/// キャンセルボタンを押した場合、他の部分をタップして閉じた場合は何も返さない(null)
class SimpleAlertDialog extends StatelessWidget {
  /// ダイアログのタイトル
  final Widget title;

  /// ダイアログのコンテンツ
  final Widget content;

  /// ポジティブボタンのテキスト
  final String positiveButtonText;

  SimpleAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.positiveButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("キャンセル"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(positiveButtonText),
        ),
      ],
    );
  }
}
