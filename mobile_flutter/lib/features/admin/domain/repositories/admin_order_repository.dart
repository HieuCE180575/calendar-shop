import '../entities/admin_order.dart';

abstract class AdminOrderRepository {
  Future<List<AdminOrder>> getOrders({
    String? search,
    String? status,
  });

  Future<void> updateOrderStatus(int id, String status, {String? note});
}
