import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getMyOrders();
  Future<void> reorder(int orderId);
}
