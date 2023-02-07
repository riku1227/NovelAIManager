import 'package:freezed_annotation/freezed_annotation.dart';

part 'manager_setting.freezed.dart';
part 'manager_setting.g.dart';

@unfreezed
class ManagerSetting with _$ManagerSetting {
  factory ManagerSetting({
    //アップデートを自動で確認するかどうか
    @Default(true) bool isAutoCheckForUpdates,
  }) = _ManagerSetting;

  factory ManagerSetting.fromJson(Map<String, Object?> json) =>
      _$ManagerSettingFromJson(json);
}
