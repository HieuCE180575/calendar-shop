import 'package:freezed_annotation/freezed_annotation.dart';
import 'app_user.dart';

part 'auth_result.freezed.dart';

@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult({
    required String token,
    required AppUser user,
  }) = _AuthResult;
}
