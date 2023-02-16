// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_sorter_button_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ImageSorterButtonSetting _$$_ImageSorterButtonSettingFromJson(
        Map<String, dynamic> json) =>
    _$_ImageSorterButtonSetting(
      label: json['label'] as String,
      folderName: json['folder_name'] as String,
      keys: (json['keys'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_ImageSorterButtonSettingToJson(
        _$_ImageSorterButtonSetting instance) =>
    <String, dynamic>{
      'label': instance.label,
      'folder_name': instance.folderName,
      'keys': instance.keys,
    };
