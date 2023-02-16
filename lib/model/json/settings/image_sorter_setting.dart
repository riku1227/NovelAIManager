import 'package:freezed_annotation/freezed_annotation.dart';

import 'image_sorter_button_setting.dart';

part 'image_sorter_setting.freezed.dart';
part 'image_sorter_setting.g.dart';

@unfreezed
class ImageSorterSetting with _$ImageSorterSetting {
  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  factory ImageSorterSetting({
    //読み込んだ画像をランダム並び替えて表示する用にする
    @Default(true) bool isRandomDisplay,
    //ファイルを移動では無くコピーさせる
    @Default(false) bool isCopyFile,
    //移動ボタンのリスト
    @Default([]) List<ImageSorterButtonSetting> buttons,
  }) = _ImageSorterSetting;

  factory ImageSorterSetting.fromJson(Map<String, Object?> json) =>
      _$ImageSorterSettingFromJson(json);
}
