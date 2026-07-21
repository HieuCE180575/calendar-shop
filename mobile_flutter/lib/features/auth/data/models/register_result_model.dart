import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_result_model.freezed.dart';
part 'register_result_model.g.dart';

@freezed
class RegisterResultModel with _$RegisterResultModel {
  const factory RegisterResultModel({
    required String message,
  }) = _RegisterResultModel;

  factory RegisterResultModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResultModelFromJson(json);
}
