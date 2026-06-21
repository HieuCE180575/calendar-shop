import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/app_user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int userId,
    required String fullName,
    String? email,
    String? phone,
    required String role,
    required String status,
    String? avatarUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelMapper on UserModel {
  AppUser toEntity() => AppUser(
        userId: userId,
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
        status: status,
        avatarUrl: avatarUrl,
      );
}
