import 'package:novelai_manager/model/json/nai_parameter.dart';
import 'package:novelai_manager/prompt/image_metadata/web_ui_metadata.dart';

/// プロンプトやネガティブプロンプトなどのどのメタデータタイプにも存在する
/// 物だけを入れた汎用パラメータークラス
class GenericMetaData {
  //プロンプト
  String prompt;

  //ネガティブプロンプト
  String negativePrompt;

  //ステップ数
  int steps;

  //スケール
  double scale;

  //シード値
  double seed;

  GenericMetaData({
    required this.prompt,
    required this.negativePrompt,
    required this.steps,
    required this.scale,
    required this.seed,
  });

  /// NovelAI方式のメタデータから変換する
  static GenericMetaData fromNAIParameter(
      String prompt, NAIParameter parameter) {
    return GenericMetaData(
        prompt: prompt,
        negativePrompt: parameter.uc,
        steps: parameter.steps,
        scale: parameter.scale,
        seed: parameter.seed);
  }

  /// Stable Diffusion web UI方式のメタデータから変換する
  static GenericMetaData fromWebUIParameter(WebUIMetaData webUIMetaData) {
    return GenericMetaData(
        prompt: webUIMetaData.prompt,
        negativePrompt: webUIMetaData.negativePrompt,
        steps: webUIMetaData.steps,
        scale: webUIMetaData.scale,
        seed: webUIMetaData.seed);
  }
}
