import 'package:realm/realm.dart';

part 'gallery_schema.g.dart';

/// ギャラリーデータのモデル
@RealmModel()
class _GalleryData {
  @PrimaryKey()
  late Uuid id;
  //ギャラリーのタイトル
  late String title;
  //ギャラリーを作った日
  late DateTime createdAt;
  //ギャラリーを更新した日;
  late DateTime updatedAt;
  //フォルダーかどうか
  bool isFolder = false;
  //プロンプトデータ
  _PromptData? promptData;
  //フォルダーデータ
  _FolderData? folderData;
}

/// フォルダーデータのモデル
/// いつかフォルダー機能実装したいと思ってとりあえず作ったけど
/// どういう感じに実装するかも決まってないからなんとも言えない
@RealmModel()
class _FolderData {
  @PrimaryKey()
  late Uuid id;
  //フォルダの名前
  String name = "";
  //フォルダの説明
  String description = "";
}

/// プロンプトデータのモデル
@RealmModel()
class _PromptData {
  @PrimaryKey()
  late Uuid id;
  //プロンプトの説明
  String description = "";

  //生成画像
  /// 画像ファイルのパス
  List<_ImageData> generatedImageList = List.empty(growable: true);

  //プロンプトのリスト
  List<String> prompt = List.empty(growable: true);

  //生成に使用するモデル
  String baseModel = "nai_diffusion_anime_full";

  //********* Image Resolution *********

  //横の解像度
  int width = 512;

  //縦の解像度
  int height = 768;

  //********* Uploaded Image Settings *********

  //AIの補正(?)の強さ (小さくなるほど元の絵が残るようになる)
  double strength = 0.5;

  //ノイズ (詳しく知らない...)
  ///TODO ノイズについて言語化出来たら更新
  double noise = 0;

  //********* Model-Specific Settings *********

  //Undesired (非表示？望ましくない？) プロンプト
  /// ------------
  /// 現状「Undesired Content」は複数行書けないけど
  /// 将来的に書けるようになる可能性もあるので一応リストにしておく
  ///    - 2022/10/10
  /// ------------
  List<String> undesiredPrompt = List.empty(growable: true);

  //Undesired (非表示？望ましくない？) にしたいコンテンツ
  String undesiredContent = "lowquality_plus_badanatomy";

  //クオリティタグを自動的につけるか
  bool addQualityTag = true;

  //ステップ
  int steps = 28;

  //スケール
  int scale = 11;

  //シード値
  double? seed;

  //Advanced: Sampling
  String sampling = "k_euler_ancestral";
}

/// 画像データのモデル
@RealmModel()
class _ImageData {
  @PrimaryKey()
  late Uuid id;

  //画像の説明
  String description = "";

  //画像のファイルパス
  late String imagePath;

  //画像のシード値
  double? imgSeed;
}
