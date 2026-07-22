import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/get_my_orders_usecase.dart';
import '../../domain/usecases/get_order_detail_usecase.dart';
import '../../domain/usecases/cancel_order_usecase.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_vnpay_url_usecase.dart';
import '../../domain/usecases/reorder_usecase.dart';
import '../../domain/entities/order.dart';

part 'order_provider.g.dart';

/// Provider khởi tạo và cung cấp OrderRemoteDataSource
@riverpod
OrderRemoteDataSource orderRemoteDataSource(OrderRemoteDataSourceRef ref) {
  return OrderRemoteDataSource(ref.watch(apiClientProvider));
}

/// Provider khởi tạo và cung cấp OrderRepository
@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepositoryImpl(ref.watch(orderRemoteDataSourceProvider));
}

/// Provider cung cấp GetMyOrdersUseCase
@riverpod
GetMyOrdersUseCase getMyOrdersUseCase(GetMyOrdersUseCaseRef ref) {
  return GetMyOrdersUseCase(ref.watch(orderRepositoryProvider));
}

/// Provider cung cấp GetOrderDetailUseCase
@riverpod
GetOrderDetailUseCase getOrderDetailUseCase(GetOrderDetailUseCaseRef ref) {
  return GetOrderDetailUseCase(ref.watch(orderRepositoryProvider));
}

/// Provider cung cấp CancelOrderUseCase
@riverpod
CancelOrderUseCase cancelOrderUseCase(CancelOrderUseCaseRef ref) {
  return CancelOrderUseCase(ref.watch(orderRepositoryProvider));
}

/// Provider cung cấp CreateOrderUseCase
@riverpod
CreateOrderUseCase createOrderUseCase(CreateOrderUseCaseRef ref) {
  return CreateOrderUseCase(ref.watch(orderRepositoryProvider));
}

/// Provider cung cấp GetVNPayUrlUseCase
@riverpod
GetVNPayUrlUseCase getVNPayUrlUseCase(GetVNPayUrlUseCaseRef ref) {
  return GetVNPayUrlUseCase(ref.watch(orderRepositoryProvider));
}

/// Notifier quản lý danh sách đơn hàng bất đồng bộ
@riverpod
class MyOrders extends _$MyOrders {
  @override
  FutureOr<List<OrderEntity>> build() {
    // Thực thi Use Case lấy danh sách đơn hàng khi khởi tạo
    return ref.watch(getMyOrdersUseCaseProvider)();
  }

  /// Hủy đơn hàng Pending
  Future<void> cancelOrder(int orderId, String? reason) async {
    try {
      await ref.read(cancelOrderUseCaseProvider)(orderId, reason);
      ref.invalidateSelf(); // Buộc Provider reload lại danh sách mới
    } catch (e) {
      rethrow;
    }
  }
}

/// Notifier quản lý chi tiết đơn hàng bất đồng bộ
@riverpod
class OrderDetail extends _$OrderDetail {
  @override
  FutureOr<OrderEntity> build(int orderId) {
    return ref.watch(getOrderDetailUseCaseProvider)(orderId);
  }
}

@riverpod
ReorderUseCase reorderUseCase(ReorderUseCaseRef ref) {
  return ReorderUseCase(ref.watch(orderRepositoryProvider));
}

@riverpod
class ReorderAction extends _$ReorderAction {
  @override
  void build() {}

  Future<void> reorder(int orderId) async {
    await ref.read(reorderUseCaseProvider)(orderId);
  }
}

