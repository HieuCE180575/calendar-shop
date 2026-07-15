import '../entities/order.dart';
<<<<<<< HEAD
import '../entities/create_order_input.dart';
=======
import '../../data/models/create_order_request.dart';
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)

/// Hợp đồng nghiệp vụ đơn hàng ở tầng Domain.
/// Định nghĩa các hành vi nghiệp vụ mà Frontend cần sử dụng.
abstract class OrderRepository {
  /// Lấy danh sách đơn hàng của người dùng hiện tại
  Future<List<OrderEntity>> getMyOrders();

  /// Lấy chi tiết một đơn hàng theo ID
  Future<OrderEntity> getOrderById(int id);

  /// Hủy một đơn hàng đang ở trạng thái Pending
  Future<void> cancelOrder(int id, String? reason);

  /// Tạo một đơn hàng mới
<<<<<<< HEAD
  Future<OrderEntity> createOrder(CreateOrderInput input);
=======
  Future<OrderEntity> createOrder(CreateOrderRequest request);
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)

  /// Lấy VNPay Payment URL
  Future<String> getVNPayUrl(int orderId);
}
