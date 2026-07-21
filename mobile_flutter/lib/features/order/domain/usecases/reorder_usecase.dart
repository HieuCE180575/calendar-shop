import '../repositories/order_repository.dart';

class ReorderUseCase {
  final OrderRepository repository;

  ReorderUseCase(this.repository);

  Future<void> call(int orderId) {
    return repository.reorder(orderId);
  }
}
