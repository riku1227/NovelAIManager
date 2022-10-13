enum BaseModel {
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

  const BaseModel(this.value, this.name);

  @override
  String toString() {
    return value;
  }
}
