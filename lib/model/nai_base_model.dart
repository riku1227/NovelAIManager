/// Enumは大文字で書きたい...
// ignore_for_file: constant_identifier_names

enum NAIBaseModel {
  NAI_DIFFUSION_ANIME_CURATED(
    "nai_diffusion_anime_curated",
    "NAI Diffusion Anime (Curated)",
  ),
  NAI_DIFFUSION_ANIME_FULL(
    "nai_diffusion_anime_full",
    "NAI Diffusion Anime (Full)",
  ),
  NAI_DIFFUSION_FURRY(
    "nai_diffusion_furry",
    "NAI Diffusion Furry (BETA)",
  );

  //データベースに保存するときとかに使う値
  final String value;
  //UIで表示するときに使用する名前
  final String name;

  const NAIBaseModel(this.value, this.name);

  @override
  String toString() {
    return value;
  }

  /// Enumの名前をvalueから取得する
  static String getNameByValue(String value) {
    var result = "";
    if (NAIBaseModel.NAI_DIFFUSION_ANIME_CURATED.value == value) {
      result = NAIBaseModel.NAI_DIFFUSION_ANIME_CURATED.name;
    } else if (NAIBaseModel.NAI_DIFFUSION_ANIME_FULL.value == value) {
      result = NAIBaseModel.NAI_DIFFUSION_ANIME_FULL.name;
    } else if (NAIBaseModel.NAI_DIFFUSION_FURRY.value == value) {
      result = NAIBaseModel.NAI_DIFFUSION_FURRY.value;
    }

    return result;
  }
}
