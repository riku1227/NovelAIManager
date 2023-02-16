// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_sorter_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ImageSorterSetting _$$_ImageSorterSettingFromJson(
        Map<String, dynamic> json) =>
    _$_ImageSorterSetting(
      isRandomDisplay: json['is_random_display'] as bool? ?? true,
      isCopyFile: json['is_copy_file'] as bool? ?? false,
      buttons: (json['buttons'] as List<dynamic>?)
              ?.map((e) =>
                  ImageSorterButtonSetting.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_ImageSorterSettingToJson(
        _$_ImageSorterSetting instance) =>
    <String, dynamic>{
      'is_random_display': instance.isRandomDisplay,
      'is_copy_file': instance.isCopyFile,
      'buttons': instance.buttons.map((e) => e.toJson()).toList(),
    };
