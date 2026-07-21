import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';

part 'order_provider.g.dart';

@riverpod
OrderRemoteDataSource orderRemoteDataSource(OrderRemoteDataSourceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrderRemoteDataSource(apiClient);
}

@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  final remoteDataSource = ref.watch(orderRemoteDataSourceProvider);
  final apiClient = ref.watch(apiClientProvider);
  return OrderRepositoryImpl(
    remoteDataSource: remoteDataSource,
    apiClient: apiClient,
  );
}

@riverpod
Future<List<OrderEntity>> myOrders(MyOrdersRef ref) {
  return ref.watch(orderRepositoryProvider).getMyOrders();
}

@riverpod
class ReorderAction extends _$ReorderAction {
  @override
  void build() {}

  Future<void> reorder(int orderId) async {
    await ref.read(orderRepositoryProvider).reorder(orderId);
  }
}
