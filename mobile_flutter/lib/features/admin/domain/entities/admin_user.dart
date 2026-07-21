import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_user.freezed.dart';

@freezed
class AdminUser with _$AdminUser {
  const factory AdminUser({
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
  }) = _AdminUser;
}
