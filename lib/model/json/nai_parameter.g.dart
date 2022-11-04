// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nai_parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NAIParameter _$$_NAIParameterFromJson(Map<String, dynamic> json) =>
    _$_NAIParameter(
      json['steps'] as int,
      json['sampler'] as String,
      (json['seed'] as num).toDouble(),
      (json['strength'] as num).toDouble(),
      (json['noise'] as num).toDouble(),
      (json['scale'] as num).toDouble(),
      json['uc'] as String,
    );

Map<String, dynamic> _$$_NAIParameterToJson(_$_NAIParameter instance) =>
    <String, dynamic>{
      'steps': instance.steps,
      'sampler': instance.sampler,
      'seed': instance.seed,
      'strength': instance.strength,
      'noise': instance.noise,
      'scale': instance.scale,
      'uc': instance.uc,
    };
