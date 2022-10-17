import 'package:flutter/material.dart';

/// データを削除する時に使うアラートダイアログ
/// 削除する場合はtrueを返す
/// 削除しない(キャンセルの)場合は何も返さない(null)
class DeleteAlertDialog extends StatelessWidget {
  const DeleteAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("データを削除しますか？"),
      content: const Text("削除したデータを復元することは出来ません"),
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
          child: const Text("削除する"),
        ),
      ],
    );
  }
}
