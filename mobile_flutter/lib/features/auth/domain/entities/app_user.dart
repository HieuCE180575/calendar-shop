import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required int userId,
    required String fullName,
    String? email,
    String? phone,
    required String role,
    required String status,
    String? avatarUrl,
  }) = _AppUser;
}
