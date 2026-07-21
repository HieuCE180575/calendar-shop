import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/admin_user_model.dart';

class AdminUserRemoteDataSource {
  final ApiClient apiClient;

  AdminUserRemoteDataSource(this.apiClient);

  Future<List<AdminUserModel>> getUsers({String? search, String? role, String? status}) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.users, queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (role != null && role.trim().isNotEmpty) 'role': role.trim(),
        if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
      });
      final data = response.data;
      final list = data is Map && data['value'] is List ? data['value'] as List : data as List;
      return list.map((e) => AdminUserModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<AdminUserModel> getUserById(int id) async {
    try {
      final response = await apiClient.dio.get('${ApiConstants.users}/$id');
      return AdminUserModel.fromJson(Map<String, dynamic>.from(response.data as Map));
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> updateStatus({required int id, required String status}) async {
    try {
      await apiClient.dio.put('${ApiConstants.users}/$id/status', data: {'status': status});
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> updateRole({required int id, required String role}) async {
    try {
      await apiClient.dio.put('${ApiConstants.users}/$id/role', data: {'role': role});
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
