import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/admin_dashboard_stats_model.dart';

class AdminDashboardRemoteDataSource {
  final ApiClient apiClient;

  AdminDashboardRemoteDataSource(this.apiClient);

  Future<AdminDashboardStatsModel> getDashboardStats() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.adminDashboard);
      return AdminDashboardStatsModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<List<int>> exportRevenueExcel() async {
    try {
      final response = await apiClient.dio.get<List<int>>(
        '${ApiConstants.adminDashboard}/export-revenue',
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data ?? <int>[];
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
