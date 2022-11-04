import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nai_parameter.freezed.dart';
part 'nai_parameter.g.dart';

/// NovelAIの画像についているメタデータにあるパラメーターのJSON用モデル
@freezed
class NAIParameter with _$NAIParameter {
  const factory NAIParameter(
    int steps,
    String sampler,
    double seed,
    double strength,
    double noise,
    double scale,
    String uc,
  ) = _NAIParameter;

  factory NAIParameter.fromJson(Map<String, Object?> json) =>
      _$NAIParameterFromJson(json);
}
