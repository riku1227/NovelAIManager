import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 細かくカテゴリ分けするほどの物じゃ無い便利機能をまとめるクラス
class GeneralUtil {
  /// クリップボードにテキストをコピーする
  /// コピー後スナックバーでメッセージが表示される
  static Future<void> copyToClipboard(
      BuildContext context, String copyText) async {
    /// 非同期処理した後にBuildContextを扱うとエラーを吐く
    /// なので処理前にBuildContextを使ってメッセンジャーを取得しておく
    final messenger = ScaffoldMessenger.of(context);
    final data = ClipboardData(text: copyText);
    await Clipboard.setData(data);

    messenger.showSnackBar(
      const SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text("クリップボードにコピーしました")),
    );
  }
}
