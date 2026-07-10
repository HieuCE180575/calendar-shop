import '../entities/order.dart';
import '../repositories/order_repository.dart';

/// Use Case chịu trách nhiệm lấy danh sách đơn hàng của người dùng.
class GetMyOrdersUseCase {
  final OrderRepository repository;

  GetMyOrdersUseCase(this.repository);

  /// Hàm call để thực thi Use Case
  Future<List<OrderEntity>> call() {
    return repository.getMyOrders();
  }
}
