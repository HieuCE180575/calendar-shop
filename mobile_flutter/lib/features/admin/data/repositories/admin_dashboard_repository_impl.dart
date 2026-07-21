import '../../domain/entities/admin_dashboard_stats.dart';
import '../../domain/repositories/admin_dashboard_repository.dart';
import '../datasources/admin_dashboard_remote_datasource.dart';
import '../models/admin_dashboard_stats_model.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  final AdminDashboardRemoteDataSource remoteDataSource;

  AdminDashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<AdminDashboardStats> getDashboardStats() async {
    final model = await remoteDataSource.getDashboardStats();
    return model.toEntity();
  }

  @override
  Future<List<int>> exportRevenueExcel() {
    return remoteDataSource.exportRevenueExcel();
  }
}
