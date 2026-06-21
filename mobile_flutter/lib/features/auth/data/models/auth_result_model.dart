import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_result.dart';
import 'user_model.dart';

part 'auth_result_model.freezed.dart';
part 'auth_result_model.g.dart';

@freezed
class AuthResultModel with _$AuthResultModel {
  const factory AuthResultModel({
    required String token,
    required String refreshToken,
    required UserModel user,
  }) = _AuthResultModel;

  factory AuthResultModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResultModelFromJson(json);
}

extension AuthResultModelMapper on AuthResultModel {
  AuthResult toEntity() => AuthResult(
        token: token,
        refreshToken: refreshToken,
        user: user.toEntity(),
      );
}
