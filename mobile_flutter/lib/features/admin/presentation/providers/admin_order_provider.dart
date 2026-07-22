import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/admin_order.dart';
import '../../domain/repositories/admin_order_repository.dart';
import '../../data/datasources/admin_order_remote_datasource.dart';
import '../../data/repositories/admin_order_repository_impl.dart';
import '../../domain/usecases/get_admin_orders_usecase.dart';
import '../../domain/usecases/update_admin_order_status_usecase.dart';

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
GetAdminOrdersUseCase getAdminOrdersUseCase(GetAdminOrdersUseCaseRef ref) {
  return GetAdminOrdersUseCase(ref.watch(adminOrderRepositoryProvider));
}

@riverpod
UpdateAdminOrderStatusUseCase updateAdminOrderStatusUseCase(UpdateAdminOrderStatusUseCaseRef ref) {
  return UpdateAdminOrderStatusUseCase(ref.watch(adminOrderRepositoryProvider));
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
  final getAdminOrdersUseCase = ref.watch(getAdminOrdersUseCaseProvider);
  final search = ref.watch(adminOrderSearchQueryProvider);
  final status = ref.watch(adminOrderStatusFilterProvider);

  return getAdminOrdersUseCase(search: search, status: status);
}

@riverpod
class AdminOrderAction extends _$AdminOrderAction {
  @override
  bool build() => false; // isLoading

  Future<bool> updateStatus(int id, String status, {String? note}) async {
    state = true;
    try {
      await ref.read(updateAdminOrderStatusUseCaseProvider)(id, status, note: note);
      ref.invalidate(adminOrdersProvider);
      state = false;
      return true;
    } catch (_) {
      state = false;
      return false;
    }
  }
}

