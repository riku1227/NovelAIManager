/// コンバーターのパースしたデータを入れるクラス
class PromptParseData {
  // プロンプトのテキスト
  String text;
  // プロンプトの強度
  double power;

  PromptParseData({
    required this.text,
    required this.power,
  });

  @override
  String toString() {
    return "[text: '$text', power: $power]";
  }
}
