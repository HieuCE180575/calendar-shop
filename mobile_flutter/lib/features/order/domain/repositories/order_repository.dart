import '../entities/order.dart';

/// Hợp đồng nghiệp vụ đơn hàng ở tầng Domain.
/// Định nghĩa các hành vi nghiệp vụ mà Frontend cần sử dụng.
abstract class OrderRepository {
  /// Lấy danh sách đơn hàng của người dùng hiện tại
  Future<List<OrderEntity>> getMyOrders();

  /// Lấy chi tiết một đơn hàng theo ID
  Future<OrderEntity> getOrderById(int id);

  /// Hủy một đơn hàng đang ở trạng thái Pending
  Future<void> cancelOrder(int id, String? reason);
}
