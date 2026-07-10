import '../repositories/order_repository.dart';

/// Use Case chịu trách nhiệm hủy đơn hàng đang ở trạng thái Pending.
class CancelOrderUseCase {
  final OrderRepository repository;

  CancelOrderUseCase(this.repository);

  /// Thực thi hủy đơn hàng
  Future<void> call(int id, String? reason) {
    return repository.cancelOrder(id, reason);
  }
}
