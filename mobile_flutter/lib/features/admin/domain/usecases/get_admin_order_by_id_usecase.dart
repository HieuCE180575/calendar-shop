import '../entities/admin_order.dart';
import '../repositories/admin_order_repository.dart';

class GetAdminOrderByIdUseCase {
  final AdminOrderRepository repository;

  GetAdminOrderByIdUseCase(this.repository);

  Future<AdminOrder> call(int id) {
    return repository.getOrderById(id);
  }
}

