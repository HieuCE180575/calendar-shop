import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.remoteDataSource, required this.tokenStorage});

  @override
  Future<AuthResult> login({required String login, required String password}) async {
    final result = await remoteDataSource.login(login: login, password: password);
    await tokenStorage.saveToken(result.token);
    await tokenStorage.saveRefreshToken(result.refreshToken);
    return result.toEntity();
  }

  @override
  Future<String> register({required String fullName, String? email, String? phone, required String password}) async {
    final result = await remoteDataSource.register(fullName: fullName, email: email, phone: phone, password: password);
    return result.message;
  }

  @override
  Future<AppUser> me() async {
    final userModel = await remoteDataSource.me();
    return userModel.toEntity();
  }

  @override
  Future<AppUser> updateProfile({
    required String fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    final userModel = await remoteDataSource.updateProfile(
      fullName: fullName,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
      gender: gender,
      dateOfBirth: dateOfBirth,
    );
    return userModel.toEntity();
  }

  @override
  Future<void> changePassword({required String oldPassword, required String newPassword}) {
    return remoteDataSource.changePassword(oldPassword: oldPassword, newPassword: newPassword);
  }

  @override
  Future<ForgotPasswordResult> forgotPassword({required String login}) async {
    final result = await remoteDataSource.forgotPassword(login: login);
    return ForgotPasswordResult(
      message: result.message,
      expiredAt: result.expiredAt,
    );
  }

  @override
  Future<void> resetPassword({required String resetToken, required String newPassword}) {
    return remoteDataSource.resetPassword(resetToken: resetToken, newPassword: newPassword);
  }

  @override
  Future<String> confirmEmail({required String token}) async {
    final result = await remoteDataSource.confirmEmail(token: token);
    return result.message;
  }

  @override
  Future<String> resendEmailConfirmation({required String email}) async {
    final result = await remoteDataSource.resendEmailConfirmation(email: email);
    return result.message;
  }

  @override
  Future<void> logout() async {
    final refreshToken = await tokenStorage.getRefreshToken();
    try {
      await remoteDataSource.logout(refreshToken: refreshToken);
    } finally {
      await tokenStorage.clearTokens();
    }
  }
}
