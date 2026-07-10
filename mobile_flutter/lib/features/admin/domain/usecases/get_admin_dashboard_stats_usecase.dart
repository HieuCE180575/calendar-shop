import '../entities/admin_dashboard_stats.dart';
import '../repositories/admin_dashboard_repository.dart';

class GetAdminDashboardStatsUseCase {
  final AdminDashboardRepository repository;

  GetAdminDashboardStatsUseCase(this.repository);

  Future<AdminDashboardStats> call() {
    return repository.getDashboardStats();
  }
}
