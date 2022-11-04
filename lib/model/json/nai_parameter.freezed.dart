// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'nai_parameter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NAIParameter _$NAIParameterFromJson(Map<String, dynamic> json) {
  return _NAIParameter.fromJson(json);
}

/// @nodoc
mixin _$NAIParameter {
  int get steps => throw _privateConstructorUsedError;
  String get sampler => throw _privateConstructorUsedError;
  double get seed => throw _privateConstructorUsedError;
  double get strength => throw _privateConstructorUsedError;
  double get noise => throw _privateConstructorUsedError;
  double get scale => throw _privateConstructorUsedError;
  String get uc => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NAIParameterCopyWith<NAIParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NAIParameterCopyWith<$Res> {
  factory $NAIParameterCopyWith(
          NAIParameter value, $Res Function(NAIParameter) then) =
      _$NAIParameterCopyWithImpl<$Res, NAIParameter>;
  @useResult
  $Res call(
      {int steps,
      String sampler,
      double seed,
      double strength,
      double noise,
      double scale,
      String uc});
}

/// @nodoc
class _$NAIParameterCopyWithImpl<$Res, $Val extends NAIParameter>
    implements $NAIParameterCopyWith<$Res> {
  _$NAIParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? steps = null,
    Object? sampler = null,
    Object? seed = null,
    Object? strength = null,
    Object? noise = null,
    Object? scale = null,
    Object? uc = null,
  }) {
    return _then(_value.copyWith(
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int,
      sampler: null == sampler
          ? _value.sampler
          : sampler // ignore: cast_nullable_to_non_nullable
              as String,
      seed: null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as double,
      strength: null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
      noise: null == noise
          ? _value.noise
          : noise // ignore: cast_nullable_to_non_nullable
              as double,
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      uc: null == uc
          ? _value.uc
          : uc // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NAIParameterCopyWith<$Res>
    implements $NAIParameterCopyWith<$Res> {
  factory _$$_NAIParameterCopyWith(
          _$_NAIParameter value, $Res Function(_$_NAIParameter) then) =
      __$$_NAIParameterCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int steps,
      String sampler,
      double seed,
      double strength,
      double noise,
      double scale,
      String uc});
}

/// @nodoc
class __$$_NAIParameterCopyWithImpl<$Res>
    extends _$NAIParameterCopyWithImpl<$Res, _$_NAIParameter>
    implements _$$_NAIParameterCopyWith<$Res> {
  __$$_NAIParameterCopyWithImpl(
      _$_NAIParameter _value, $Res Function(_$_NAIParameter) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? steps = null,
    Object? sampler = null,
    Object? seed = null,
    Object? strength = null,
    Object? noise = null,
    Object? scale = null,
    Object? uc = null,
  }) {
    return _then(_$_NAIParameter(
      null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int,
      null == sampler
          ? _value.sampler
          : sampler // ignore: cast_nullable_to_non_nullable
              as String,
      null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as double,
      null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
      null == noise
          ? _value.noise
          : noise // ignore: cast_nullable_to_non_nullable
              as double,
      null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      null == uc
          ? _value.uc
          : uc // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NAIParameter with DiagnosticableTreeMixin implements _NAIParameter {
  const _$_NAIParameter(this.steps, this.sampler, this.seed, this.strength,
      this.noise, this.scale, this.uc);

  factory _$_NAIParameter.fromJson(Map<String, dynamic> json) =>
      _$$_NAIParameterFromJson(json);

  @override
  final int steps;
  @override
  final String sampler;
  @override
  final double seed;
  @override
  final double strength;
  @override
  final double noise;
  @override
  final double scale;
  @override
  final String uc;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NAIParameter(steps: $steps, sampler: $sampler, seed: $seed, strength: $strength, noise: $noise, scale: $scale, uc: $uc)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NAIParameter'))
      ..add(DiagnosticsProperty('steps', steps))
      ..add(DiagnosticsProperty('sampler', sampler))
      ..add(DiagnosticsProperty('seed', seed))
      ..add(DiagnosticsProperty('strength', strength))
      ..add(DiagnosticsProperty('noise', noise))
      ..add(DiagnosticsProperty('scale', scale))
      ..add(DiagnosticsProperty('uc', uc));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NAIParameter &&
            (identical(other.steps, steps) || other.steps == steps) &&
            (identical(other.sampler, sampler) || other.sampler == sampler) &&
            (identical(other.seed, seed) || other.seed == seed) &&
            (identical(other.strength, strength) ||
                other.strength == strength) &&
            (identical(other.noise, noise) || other.noise == noise) &&
            (identical(other.scale, scale) || other.scale == scale) &&
            (identical(other.uc, uc) || other.uc == uc));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, steps, sampler, seed, strength, noise, scale, uc);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NAIParameterCopyWith<_$_NAIParameter> get copyWith =>
      __$$_NAIParameterCopyWithImpl<_$_NAIParameter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NAIParameterToJson(
      this,
    );
  }
}

abstract class _NAIParameter implements NAIParameter {
  const factory _NAIParameter(
      final int steps,
      final String sampler,
      final double seed,
      final double strength,
      final double noise,
      final double scale,
      final String uc) = _$_NAIParameter;

  factory _NAIParameter.fromJson(Map<String, dynamic> json) =
      _$_NAIParameter.fromJson;

  @override
  int get steps;
  @override
  String get sampler;
  @override
  double get seed;
  @override
  double get strength;
  @override
  double get noise;
  @override
  double get scale;
  @override
  String get uc;
  @override
  @JsonKey(ignore: true)
  _$$_NAIParameterCopyWith<_$_NAIParameter> get copyWith =>
      throw _privateConstructorUsedError;
}
