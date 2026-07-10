import '../entities/order.dart';
import '../repositories/order_repository.dart';

/// Use Case chịu trách nhiệm lấy chi tiết một đơn hàng.
class GetOrderDetailUseCase {
  final OrderRepository repository;

  GetOrderDetailUseCase(this.repository);

  /// Thực thi lấy chi tiết đơn hàng theo ID
  Future<OrderEntity> call(int id) {
    return repository.getOrderById(id);
  }
}
