import '../entities/auth_result.dart';
import '../entities/app_user.dart';

class ForgotPasswordResult {
  final String message;
  final DateTime? expiredAt;

  const ForgotPasswordResult({
    required this.message,
    this.expiredAt,
  });
}

abstract class AuthRepository {
  Future<AuthResult> login({required String login, required String password});
  Future<AuthResult> googleLogin({required String email, String? fullName, String? photoUrl, String? idToken});
  Future<String> register({required String fullName, String? email, String? phone, required String password});
  Future<AppUser> me();
  Future<AppUser> updateProfile({
    required String fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
  });
  Future<void> changePassword({required String oldPassword, required String newPassword});
  Future<ForgotPasswordResult> forgotPassword({required String login});
  Future<String> verifyResetCode({required String resetCode});
  Future<void> resetPassword({required String resetToken, required String newPassword});
  Future<String> confirmEmail({required String email, required String otp});
  Future<String> resendEmailConfirmation({required String email});
  Future<void> logout();
}
