import '../entities/order.dart';
import '../entities/create_order_input.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<OrderEntity> call(CreateOrderInput input) {
    return repository.createOrder(input);
  }
}
