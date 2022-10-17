import 'package:novelai_manager/model/schema/gallery_schema.dart';
import 'package:realm/realm.dart';

class GalleryDataUtil {
  static GalleryData copyGalleryData(GalleryData galleryData) {
    /// コピーした後のギャラリーデータ
    final copyGalleryData = GalleryData(
      galleryData.id,
      galleryData.title,
      galleryData.createdAt,
      galleryData.updatedAt,
    );

    //コピーした後のプロンプトデータ
    final copyPrompt = PromptData(Uuid.v4());
    final originalPrompt = galleryData.promptData;
    if (originalPrompt != null) {
      /// generatedImageList以外を一端コピーする
      /// generatedImageListは中身がImageDataなのでこっちもコピーしないと行けない
      copyPrompt
        ..id = originalPrompt.id
        ..description = originalPrompt.description
        ..prompt.addAll(originalPrompt.prompt)
        ..baseModel = originalPrompt.baseModel
        ..width = originalPrompt.width
        ..height = originalPrompt.height
        ..strength = originalPrompt.strength
        ..noise = originalPrompt.noise
        ..undesiredPrompt.addAll(originalPrompt.undesiredPrompt)
        ..undesiredContent = originalPrompt.undesiredContent
        ..steps = originalPrompt.steps
        ..scale = originalPrompt.scale
        ..seed = originalPrompt.seed
        ..sampling = originalPrompt.sampling;

      /// generatedImageListのコピー
      for (var item in originalPrompt.generatedImageList) {
        final copyImageData = ImageData(item.id, item.imagePath);
        copyImageData
          ..description = item.description
          ..imgSeed = item.imgSeed;
        copyPrompt.generatedImageList.add(copyImageData);
      }
    }
    copyGalleryData.promptData = copyPrompt;

    return copyGalleryData;
  }
}
