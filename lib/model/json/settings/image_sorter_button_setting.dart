import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_sorter_button_setting.freezed.dart';
part 'image_sorter_button_setting.g.dart';

@unfreezed
class ImageSorterButtonSetting with _$ImageSorterButtonSetting {
  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  factory ImageSorterButtonSetting({
    //読み込んだ画像をランダム並び替えて表示する用にする
    required String label,
    required String folderName,
    required List<String> keys,
  }) = _ImageSorterButtonSetting;

  factory ImageSorterButtonSetting.fromJson(Map<String, Object?> json) =>
      _$ImageSorterButtonSettingFromJson(json);
}
