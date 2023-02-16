// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'image_sorter_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ImageSorterSetting _$ImageSorterSettingFromJson(Map<String, dynamic> json) {
  return _ImageSorterSetting.fromJson(json);
}

/// @nodoc
mixin _$ImageSorterSetting {
//読み込んだ画像をランダム並び替えて表示する用にする
  bool get isRandomDisplay =>
      throw _privateConstructorUsedError; //読み込んだ画像をランダム並び替えて表示する用にする
  set isRandomDisplay(bool value) =>
      throw _privateConstructorUsedError; //ファイルを移動では無くコピーさせる
  bool get isCopyFile => throw _privateConstructorUsedError; //ファイルを移動では無くコピーさせる
  set isCopyFile(bool value) => throw _privateConstructorUsedError; //移動ボタンのリスト
  List<ImageSorterButtonSetting> get buttons =>
      throw _privateConstructorUsedError; //移動ボタンのリスト
  set buttons(List<ImageSorterButtonSetting> value) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImageSorterSettingCopyWith<ImageSorterSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageSorterSettingCopyWith<$Res> {
  factory $ImageSorterSettingCopyWith(
          ImageSorterSetting value, $Res Function(ImageSorterSetting) then) =
      _$ImageSorterSettingCopyWithImpl<$Res, ImageSorterSetting>;
  @useResult
  $Res call(
      {bool isRandomDisplay,
      bool isCopyFile,
      List<ImageSorterButtonSetting> buttons});
}

/// @nodoc
class _$ImageSorterSettingCopyWithImpl<$Res, $Val extends ImageSorterSetting>
    implements $ImageSorterSettingCopyWith<$Res> {
  _$ImageSorterSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRandomDisplay = null,
    Object? isCopyFile = null,
    Object? buttons = null,
  }) {
    return _then(_value.copyWith(
      isRandomDisplay: null == isRandomDisplay
          ? _value.isRandomDisplay
          : isRandomDisplay // ignore: cast_nullable_to_non_nullable
              as bool,
      isCopyFile: null == isCopyFile
          ? _value.isCopyFile
          : isCopyFile // ignore: cast_nullable_to_non_nullable
              as bool,
      buttons: null == buttons
          ? _value.buttons
          : buttons // ignore: cast_nullable_to_non_nullable
              as List<ImageSorterButtonSetting>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ImageSorterSettingCopyWith<$Res>
    implements $ImageSorterSettingCopyWith<$Res> {
  factory _$$_ImageSorterSettingCopyWith(_$_ImageSorterSetting value,
          $Res Function(_$_ImageSorterSetting) then) =
      __$$_ImageSorterSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isRandomDisplay,
      bool isCopyFile,
      List<ImageSorterButtonSetting> buttons});
}

/// @nodoc
class __$$_ImageSorterSettingCopyWithImpl<$Res>
    extends _$ImageSorterSettingCopyWithImpl<$Res, _$_ImageSorterSetting>
    implements _$$_ImageSorterSettingCopyWith<$Res> {
  __$$_ImageSorterSettingCopyWithImpl(
      _$_ImageSorterSetting _value, $Res Function(_$_ImageSorterSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRandomDisplay = null,
    Object? isCopyFile = null,
    Object? buttons = null,
  }) {
    return _then(_$_ImageSorterSetting(
      isRandomDisplay: null == isRandomDisplay
          ? _value.isRandomDisplay
          : isRandomDisplay // ignore: cast_nullable_to_non_nullable
              as bool,
      isCopyFile: null == isCopyFile
          ? _value.isCopyFile
          : isCopyFile // ignore: cast_nullable_to_non_nullable
              as bool,
      buttons: null == buttons
          ? _value.buttons
          : buttons // ignore: cast_nullable_to_non_nullable
              as List<ImageSorterButtonSetting>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class _$_ImageSorterSetting implements _ImageSorterSetting {
  _$_ImageSorterSetting(
      {this.isRandomDisplay = true,
      this.isCopyFile = false,
      this.buttons = const []});

  factory _$_ImageSorterSetting.fromJson(Map<String, dynamic> json) =>
      _$$_ImageSorterSettingFromJson(json);

//読み込んだ画像をランダム並び替えて表示する用にする
  @override
  @JsonKey()
  bool isRandomDisplay;
//ファイルを移動では無くコピーさせる
  @override
  @JsonKey()
  bool isCopyFile;
//移動ボタンのリスト
  @override
  @JsonKey()
  List<ImageSorterButtonSetting> buttons;

  @override
  String toString() {
    return 'ImageSorterSetting(isRandomDisplay: $isRandomDisplay, isCopyFile: $isCopyFile, buttons: $buttons)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ImageSorterSettingCopyWith<_$_ImageSorterSetting> get copyWith =>
      __$$_ImageSorterSettingCopyWithImpl<_$_ImageSorterSetting>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ImageSorterSettingToJson(
      this,
    );
  }
}

abstract class _ImageSorterSetting implements ImageSorterSetting {
  factory _ImageSorterSetting(
      {bool isRandomDisplay,
      bool isCopyFile,
      List<ImageSorterButtonSetting> buttons}) = _$_ImageSorterSetting;

  factory _ImageSorterSetting.fromJson(Map<String, dynamic> json) =
      _$_ImageSorterSetting.fromJson;

  @override //読み込んだ画像をランダム並び替えて表示する用にする
  bool get isRandomDisplay; //読み込んだ画像をランダム並び替えて表示する用にする
  set isRandomDisplay(bool value);
  @override //ファイルを移動では無くコピーさせる
  bool get isCopyFile; //ファイルを移動では無くコピーさせる
  set isCopyFile(bool value);
  @override //移動ボタンのリスト
  List<ImageSorterButtonSetting> get buttons; //移動ボタンのリスト
  set buttons(List<ImageSorterButtonSetting> value);
  @override
  @JsonKey(ignore: true)
  _$$_ImageSorterSettingCopyWith<_$_ImageSorterSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
