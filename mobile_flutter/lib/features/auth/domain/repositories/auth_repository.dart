import '../entities/auth_result.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<AuthResult> login({required String login, required String password});
  Future<AuthResult> register({required String fullName, String? email, String? phone, required String password});
  Future<AppUser> me();
  Future<void> logout();
}
