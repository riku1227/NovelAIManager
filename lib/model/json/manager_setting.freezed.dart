// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'manager_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ManagerSetting _$ManagerSettingFromJson(Map<String, dynamic> json) {
  return _ManagerSetting.fromJson(json);
}

/// @nodoc
mixin _$ManagerSetting {
//アップデートを自動で確認するかどうか
  bool get isAutoCheckForUpdates =>
      throw _privateConstructorUsedError; //アップデートを自動で確認するかどうか
  set isAutoCheckForUpdates(bool value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ManagerSettingCopyWith<ManagerSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerSettingCopyWith<$Res> {
  factory $ManagerSettingCopyWith(
          ManagerSetting value, $Res Function(ManagerSetting) then) =
      _$ManagerSettingCopyWithImpl<$Res, ManagerSetting>;
  @useResult
  $Res call({bool isAutoCheckForUpdates});
}

/// @nodoc
class _$ManagerSettingCopyWithImpl<$Res, $Val extends ManagerSetting>
    implements $ManagerSettingCopyWith<$Res> {
  _$ManagerSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAutoCheckForUpdates = null,
  }) {
    return _then(_value.copyWith(
      isAutoCheckForUpdates: null == isAutoCheckForUpdates
          ? _value.isAutoCheckForUpdates
          : isAutoCheckForUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ManagerSettingCopyWith<$Res>
    implements $ManagerSettingCopyWith<$Res> {
  factory _$$_ManagerSettingCopyWith(
          _$_ManagerSetting value, $Res Function(_$_ManagerSetting) then) =
      __$$_ManagerSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isAutoCheckForUpdates});
}

/// @nodoc
class __$$_ManagerSettingCopyWithImpl<$Res>
    extends _$ManagerSettingCopyWithImpl<$Res, _$_ManagerSetting>
    implements _$$_ManagerSettingCopyWith<$Res> {
  __$$_ManagerSettingCopyWithImpl(
      _$_ManagerSetting _value, $Res Function(_$_ManagerSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAutoCheckForUpdates = null,
  }) {
    return _then(_$_ManagerSetting(
      isAutoCheckForUpdates: null == isAutoCheckForUpdates
          ? _value.isAutoCheckForUpdates
          : isAutoCheckForUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ManagerSetting implements _ManagerSetting {
  _$_ManagerSetting({this.isAutoCheckForUpdates = true});

  factory _$_ManagerSetting.fromJson(Map<String, dynamic> json) =>
      _$$_ManagerSettingFromJson(json);

//アップデートを自動で確認するかどうか
  @override
  @JsonKey()
  bool isAutoCheckForUpdates;

  @override
  String toString() {
    return 'ManagerSetting(isAutoCheckForUpdates: $isAutoCheckForUpdates)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ManagerSettingCopyWith<_$_ManagerSetting> get copyWith =>
      __$$_ManagerSettingCopyWithImpl<_$_ManagerSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ManagerSettingToJson(
      this,
    );
  }
}

abstract class _ManagerSetting implements ManagerSetting {
  factory _ManagerSetting({bool isAutoCheckForUpdates}) = _$_ManagerSetting;

  factory _ManagerSetting.fromJson(Map<String, dynamic> json) =
      _$_ManagerSetting.fromJson;

  @override //アップデートを自動で確認するかどうか
  bool get isAutoCheckForUpdates; //アップデートを自動で確認するかどうか
  set isAutoCheckForUpdates(bool value);
  @override
  @JsonKey(ignore: true)
  _$$_ManagerSettingCopyWith<_$_ManagerSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
