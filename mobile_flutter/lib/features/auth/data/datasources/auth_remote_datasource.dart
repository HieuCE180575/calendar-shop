import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<AuthResultModel> login({required String login, required String password}) async {
    try {
      final response = await apiClient.dio.post(ApiConstants.login, data: {
        'login': login,
        'password': password,
      });
      return AuthResultModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<AuthResultModel> register({required String fullName, String? email, String? phone, required String password}) async {
    try {
      final response = await apiClient.dio.post(ApiConstants.register, data: {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
      });
      return AuthResultModel.fromJson(response.data);
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
}
