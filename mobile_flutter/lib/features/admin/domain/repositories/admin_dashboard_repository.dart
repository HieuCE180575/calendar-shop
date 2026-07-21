import '../entities/admin_dashboard_stats.dart';

abstract class AdminDashboardRepository {
  Future<AdminDashboardStats> getDashboardStats();

  Future<List<int>> exportRevenueExcel();
}
