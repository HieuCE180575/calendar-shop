import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/admin_dashboard_remote_datasource.dart';
import '../../data/repositories/admin_dashboard_repository_impl.dart';
import '../../domain/entities/admin_dashboard_stats.dart';
import '../../domain/repositories/admin_dashboard_repository.dart';

part 'admin_dashboard_provider.g.dart';

@riverpod
AdminDashboardRemoteDataSource adminDashboardRemoteDataSource(
    AdminDashboardRemoteDataSourceRef ref) {
  return AdminDashboardRemoteDataSource(ref.watch(apiClientProvider));
}

@riverpod
AdminDashboardRepository adminDashboardRepository(
    AdminDashboardRepositoryRef ref) {
  return AdminDashboardRepositoryImpl(
      ref.watch(adminDashboardRemoteDataSourceProvider));
}

@riverpod
Future<AdminDashboardStats> adminDashboardStats(AdminDashboardStatsRef ref) {
  return ref.watch(adminDashboardRepositoryProvider).getDashboardStats();
}
