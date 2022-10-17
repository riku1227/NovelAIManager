/// ファイル関連のユーティリティクラス
class IOUtil {
  /// ファイル名として使用できない文字を_(アンダーバー)に変換する
  static String escapeString(String fileName) {
    return fileName.replaceAll(RegExp(r'"|<|>|\||:|\*|\?|\\|\/'), '_');
  }
}
