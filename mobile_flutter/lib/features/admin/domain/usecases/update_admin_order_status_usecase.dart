import '../repositories/admin_order_repository.dart';

class UpdateAdminOrderStatusUseCase {
  final AdminOrderRepository repository;

  UpdateAdminOrderStatusUseCase(this.repository);

  Future<void> call(int id, String status, {String? note}) {
    return repository.updateOrderStatus(id, status, note: note);
  }
}
