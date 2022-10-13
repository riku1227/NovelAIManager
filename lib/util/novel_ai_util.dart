import 'package:novelai_manager/model/base_model.dart';
import 'package:novelai_manager/model/undesired_content.dart';

class NovelAIUtil {
  ///enumのvalueでベースモデルの名前を取得する
  static String getBaseModelNamebyValue(String value) {
    var result = "";
    if (value == BaseModel.NAI_DIFFUSION_ANIME_CURATED.value) {
      result = BaseModel.NAI_DIFFUSION_ANIME_CURATED.name;
    } else if (value == BaseModel.NAI_DIFFUSION_ANIME_FULL.value) {
      result = BaseModel.NAI_DIFFUSION_ANIME_FULL.name;
    } else if (value == BaseModel.NAI_DIFFUSION_FURRY.value) {
      result = BaseModel.NAI_DIFFUSION_FURRY.name;
    }
    return result;
  }

  //enumのvalueでUndesired Contentの名前を取得する
  static String getUndesiredContentNamebyValue(String value) {
    var result = "";
    if (value == UndesiredContent.LOWQUALITY_PLUS_BADANATOMY.value) {
      result = UndesiredContent.LOWQUALITY_PLUS_BADANATOMY.name;
    } else if (value == UndesiredContent.LOWQUALITY.value) {
      result = UndesiredContent.LOWQUALITY.name;
    } else if (value == UndesiredContent.NONE.value) {
      result = UndesiredContent.NONE.name;
    }
    return result;
  }
}
