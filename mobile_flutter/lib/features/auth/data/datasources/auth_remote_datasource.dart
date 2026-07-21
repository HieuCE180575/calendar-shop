import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_result_model.dart';
import '../models/forgot_password_result_model.dart';
import '../models/message_result_model.dart';
import '../models/register_result_model.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<AuthResultModel> login({
    required String login,
    required String password,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.login,
        data: {
          'login': login,
          'password': password,
        },
      );
      return AuthResultModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<RegisterResultModel> register({
    required String fullName,
    String? email,
    String? phone,
    required String password,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.register,
        data: {
          'fullName': fullName,
          'email': _emptyToNull(email),
          'phone': _emptyToNull(phone),
          'password': password,
        },
      );
      return RegisterResultModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> logout({String? refreshToken}) async {
    try {
      await apiClient.dio.post(
        ApiConstants.logout,
        data: {
          'refreshToken': _emptyToNull(refreshToken),
        },
      );
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<UserModel> me() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.me);
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<UserModel> updateProfile({
    required String fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    try {
      final response = await apiClient.dio.put(
        ApiConstants.profile,
        data: {
          'fullName': fullName,
          'email': _emptyToNull(email),
          'phone': _emptyToNull(phone),
          'avatarUrl': _emptyToNull(avatarUrl),
          'gender': _emptyToNull(gender),
          'dateOfBirth': dateOfBirth?.toIso8601String(),
        },
      );
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await apiClient.dio.put(
        ApiConstants.changePassword,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<ForgotPasswordResultModel> forgotPassword({
    required String login,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.forgotPassword,
        data: {
          'login': login,
        },
      );
      return ForgotPasswordResultModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      await apiClient.dio.post(
        ApiConstants.resetPassword,
        data: {
          'resetToken': resetToken,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<MessageResultModel> confirmEmail({required String token}) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.confirmEmail,
        data: {
          'token': token,
        },
      );
      return MessageResultModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<MessageResultModel> resendEmailConfirmation({
    required String email,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.resendEmailConfirmation,
        data: {
          'email': email,
        },
      );
      return MessageResultModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
