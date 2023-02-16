import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:novelai_manager/model/json/settings/image_sorter_setting.dart';

part 'manager_setting.freezed.dart';
part 'manager_setting.g.dart';

@unfreezed
class ManagerSetting with _$ManagerSetting {
  factory ManagerSetting({
    //アップデートを自動で確認するかどうか
    @Default(true) bool isAutoCheckForUpdates,
    required ImageSorterSetting imageSorterSetting,
  }) = _ManagerSetting;

  factory ManagerSetting.fromJson(Map<String, Object?> json) =>
      _$ManagerSettingFromJson(json);
}
