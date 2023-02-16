// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ManagerSetting _$$_ManagerSettingFromJson(Map<String, dynamic> json) =>
    _$_ManagerSetting(
      isAutoCheckForUpdates: json['isAutoCheckForUpdates'] as bool? ?? true,
      imageSorterSetting: ImageSorterSetting.fromJson(
          json['imageSorterSetting'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ManagerSettingToJson(_$_ManagerSetting instance) =>
    <String, dynamic>{
      'isAutoCheckForUpdates': instance.isAutoCheckForUpdates,
      'imageSorterSetting': instance.imageSorterSetting,
    };
