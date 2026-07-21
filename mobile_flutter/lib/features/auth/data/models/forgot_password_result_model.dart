import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_result_model.freezed.dart';
part 'forgot_password_result_model.g.dart';

@freezed
class ForgotPasswordResultModel with _$ForgotPasswordResultModel {
  const factory ForgotPasswordResultModel({
    required String message,
    DateTime? expiredAt,
  }) = _ForgotPasswordResultModel;

  factory ForgotPasswordResultModel.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResultModelFromJson(json);
}
