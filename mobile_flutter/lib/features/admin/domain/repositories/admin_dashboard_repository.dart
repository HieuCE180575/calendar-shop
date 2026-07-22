import '../entities/admin_dashboard_stats.dart';

abstract class AdminDashboardRepository {
  Future<AdminDashboardStats> getDashboardStats([int days = 7]);

  Future<List<int>> exportRevenueExcel();
}
