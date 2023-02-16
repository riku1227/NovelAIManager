// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'image_sorter_button_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ImageSorterButtonSetting _$ImageSorterButtonSettingFromJson(
    Map<String, dynamic> json) {
  return _ImageSorterButtonSetting.fromJson(json);
}

/// @nodoc
mixin _$ImageSorterButtonSetting {
//読み込んだ画像をランダム並び替えて表示する用にする
  String get label =>
      throw _privateConstructorUsedError; //読み込んだ画像をランダム並び替えて表示する用にする
  set label(String value) => throw _privateConstructorUsedError;
  String get folderName => throw _privateConstructorUsedError;
  set folderName(String value) => throw _privateConstructorUsedError;
  List<String> get keys => throw _privateConstructorUsedError;
  set keys(List<String> value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImageSorterButtonSettingCopyWith<ImageSorterButtonSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageSorterButtonSettingCopyWith<$Res> {
  factory $ImageSorterButtonSettingCopyWith(ImageSorterButtonSetting value,
          $Res Function(ImageSorterButtonSetting) then) =
      _$ImageSorterButtonSettingCopyWithImpl<$Res, ImageSorterButtonSetting>;
  @useResult
  $Res call({String label, String folderName, List<String> keys});
}

/// @nodoc
class _$ImageSorterButtonSettingCopyWithImpl<$Res,
        $Val extends ImageSorterButtonSetting>
    implements $ImageSorterButtonSettingCopyWith<$Res> {
  _$ImageSorterButtonSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? folderName = null,
    Object? keys = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      folderName: null == folderName
          ? _value.folderName
          : folderName // ignore: cast_nullable_to_non_nullable
              as String,
      keys: null == keys
          ? _value.keys
          : keys // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ImageSorterButtonSettingCopyWith<$Res>
    implements $ImageSorterButtonSettingCopyWith<$Res> {
  factory _$$_ImageSorterButtonSettingCopyWith(
          _$_ImageSorterButtonSetting value,
          $Res Function(_$_ImageSorterButtonSetting) then) =
      __$$_ImageSorterButtonSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, String folderName, List<String> keys});
}

/// @nodoc
class __$$_ImageSorterButtonSettingCopyWithImpl<$Res>
    extends _$ImageSorterButtonSettingCopyWithImpl<$Res,
        _$_ImageSorterButtonSetting>
    implements _$$_ImageSorterButtonSettingCopyWith<$Res> {
  __$$_ImageSorterButtonSettingCopyWithImpl(_$_ImageSorterButtonSetting _value,
      $Res Function(_$_ImageSorterButtonSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? folderName = null,
    Object? keys = null,
  }) {
    return _then(_$_ImageSorterButtonSetting(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      folderName: null == folderName
          ? _value.folderName
          : folderName // ignore: cast_nullable_to_non_nullable
              as String,
      keys: null == keys
          ? _value.keys
          : keys // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class _$_ImageSorterButtonSetting implements _ImageSorterButtonSetting {
  _$_ImageSorterButtonSetting(
      {required this.label, required this.folderName, required this.keys});

  factory _$_ImageSorterButtonSetting.fromJson(Map<String, dynamic> json) =>
      _$$_ImageSorterButtonSettingFromJson(json);

//読み込んだ画像をランダム並び替えて表示する用にする
  @override
  String label;
  @override
  String folderName;
  @override
  List<String> keys;

  @override
  String toString() {
    return 'ImageSorterButtonSetting(label: $label, folderName: $folderName, keys: $keys)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ImageSorterButtonSettingCopyWith<_$_ImageSorterButtonSetting>
      get copyWith => __$$_ImageSorterButtonSettingCopyWithImpl<
          _$_ImageSorterButtonSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ImageSorterButtonSettingToJson(
      this,
    );
  }
}

abstract class _ImageSorterButtonSetting implements ImageSorterButtonSetting {
  factory _ImageSorterButtonSetting(
      {required String label,
      required String folderName,
      required List<String> keys}) = _$_ImageSorterButtonSetting;

  factory _ImageSorterButtonSetting.fromJson(Map<String, dynamic> json) =
      _$_ImageSorterButtonSetting.fromJson;

  @override //読み込んだ画像をランダム並び替えて表示する用にする
  String get label; //読み込んだ画像をランダム並び替えて表示する用にする
  set label(String value);
  @override
  String get folderName;
  set folderName(String value);
  @override
  List<String> get keys;
  set keys(List<String> value);
  @override
  @JsonKey(ignore: true)
  _$$_ImageSorterButtonSettingCopyWith<_$_ImageSorterButtonSetting>
      get copyWith => throw _privateConstructorUsedError;
}
