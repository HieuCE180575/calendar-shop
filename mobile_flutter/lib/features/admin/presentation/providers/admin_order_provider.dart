import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/admin_order.dart';
import '../../domain/repositories/admin_order_repository.dart';
import '../../data/datasources/admin_order_remote_datasource.dart';
import '../../data/repositories/admin_order_repository_impl.dart';

part 'admin_order_provider.g.dart';

@riverpod
AdminOrderRemoteDataSource adminOrderRemoteDataSource(AdminOrderRemoteDataSourceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminOrderRemoteDataSource(apiClient);
}

@riverpod
AdminOrderRepository adminOrderRepository(AdminOrderRepositoryRef ref) {
  final remoteDataSource = ref.watch(adminOrderRemoteDataSourceProvider);
  final apiClient = ref.watch(apiClientProvider);
  return AdminOrderRepositoryImpl(
    remoteDataSource: remoteDataSource,
    apiClient: apiClient,
  );
}

@riverpod
class AdminOrderSearchQuery extends _$AdminOrderSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

@riverpod
class AdminOrderStatusFilter extends _$AdminOrderStatusFilter {
  @override
  String build() => 'All';

  void setStatus(String status) {
    state = status;
  }
}

@riverpod
Future<List<AdminOrder>> adminOrders(AdminOrdersRef ref) {
  final repository = ref.watch(adminOrderRepositoryProvider);
  final search = ref.watch(adminOrderSearchQueryProvider);
  final status = ref.watch(adminOrderStatusFilterProvider);

  return repository.getOrders(search: search, status: status);
}
