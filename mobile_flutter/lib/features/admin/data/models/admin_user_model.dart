import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/admin_user.dart';

part 'admin_user_model.freezed.dart';
part 'admin_user_model.g.dart';

@freezed
class AdminUserModel with _$AdminUserModel {
  const factory AdminUserModel({
    required int userId,
    required String fullName,
    String? email,
    String? phone,
    required String role,
    required String status,
    @Default(false) bool isEmailConfirmed,
    DateTime? emailConfirmedAt,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AdminUserModel;

  factory AdminUserModel.fromJson(Map<String, dynamic> json) =>
      _$AdminUserModelFromJson(json);
}

extension AdminUserModelMapper on AdminUserModel {
  AdminUser toEntity() => AdminUser(
        userId: userId,
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
        status: status,
        isEmailConfirmed: isEmailConfirmed,
        emailConfirmedAt: emailConfirmedAt,
        avatarUrl: avatarUrl,
        gender: gender,
        dateOfBirth: dateOfBirth,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
