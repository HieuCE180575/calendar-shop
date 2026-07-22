import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(apiClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) => LoginUseCase(ref.watch(authRepositoryProvider)));
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) => RegisterUseCase(ref.watch(authRepositoryProvider)));

class AuthState {
  final bool isLoading;
  final AppUser? user;
  final String? error;
  final String? message;
  final ForgotPasswordResult? forgotPasswordResult;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
    this.message,
    this.forgotPasswordResult,
  });

  AuthState copyWith({
    bool? isLoading,
    AppUser? user,
    String? error,
    String? message,
    ForgotPasswordResult? forgotPasswordResult,
    bool clearForgotPasswordResult = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      message: message,
      forgotPasswordResult: clearForgotPasswordResult ? null : (forgotPasswordResult ?? this.forgotPasswordResult),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState());

  Future<void> login(String login, String password) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      final result = await ref.read(loginUseCaseProvider)(login: login, password: password);
      state = AuthState(user: result.user, message: 'Đăng nhập thành công.');
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> loginWithGoogle({
    required String email,
    String? fullName,
    String? photoUrl,
    String? idToken,
  }) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      final result = await ref.read(authRepositoryProvider).googleLogin(
            email: email,
            fullName: fullName,
            photoUrl: photoUrl,
            idToken: idToken,
          );
      state = AuthState(user: result.user, message: 'Đăng nhập Google thành công.');
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> register(String fullName, String email, String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      final message = await ref.read(registerUseCaseProvider)(fullName: fullName, email: email, phone: phone, password: password);
      state = AuthState(message: message);
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> loadMe() async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      final user = await ref.read(authRepositoryProvider).me();
      state = AuthState(user: user);
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<bool> updateProfile({
    required String fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      final user = await ref.read(authRepositoryProvider).updateProfile(
            fullName: fullName,
            email: email,
            phone: phone,
            avatarUrl: avatarUrl,
            gender: gender,
            dateOfBirth: dateOfBirth,
          );
      state = AuthState(user: user, message: 'Cập nhật hồ sơ thành công.');
      return true;
    } catch (e) {
      state = AuthState(user: state.user, error: e.toString());
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      await ref.read(authRepositoryProvider).changePassword(oldPassword: oldPassword, newPassword: newPassword);
      await ref.read(authRepositoryProvider).logout();
      state = const AuthState(message: 'Đổi mật khẩu thành công. Vui lòng đăng nhập lại.');
      return true;
    } catch (e) {
      state = AuthState(user: state.user, error: e.toString());
      return false;
    }
  }

  Future<bool> forgotPassword(String login) async {
    state = state.copyWith(isLoading: true, error: null, message: null, clearForgotPasswordResult: true);
    try {
      final result = await ref.read(authRepositoryProvider).forgotPassword(login: login);
      state = AuthState(
        message: result.message,
        forgotPasswordResult: result,
      );
      return true;
    } catch (e) {
      state = AuthState(error: e.toString());
      return false;
    }
  }

  Future<bool> verifyResetCode(String resetCode) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      final message = await ref.read(authRepositoryProvider).verifyResetCode(resetCode: resetCode);
      state = AuthState(message: message);
      return true;
    } catch (e) {
      state = AuthState(error: e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(String resetToken, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      await ref.read(authRepositoryProvider).resetPassword(resetToken: resetToken, newPassword: newPassword);
      state = const AuthState(message: 'Đặt lại mật khẩu thành công. Vui lòng đăng nhập.');
      return true;
    } catch (e) {
      state = AuthState(error: e.toString());
      return false;
    }
  }

  Future<bool> confirmEmail(String token) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      final message = await ref.read(authRepositoryProvider).confirmEmail(token: token);
      state = AuthState(message: message);
      return true;
    } catch (e) {
      state = AuthState(error: e.toString());
      return false;
    }
  }

  Future<bool> resendEmailConfirmation(String email) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      final message = await ref.read(authRepositoryProvider).resendEmailConfirmation(email: email);
      state = AuthState(message: message);
      return true;
    } catch (e) {
      state = AuthState(error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));
