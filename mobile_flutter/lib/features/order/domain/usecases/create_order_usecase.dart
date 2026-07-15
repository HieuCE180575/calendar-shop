import '../entities/order.dart';
import '../repositories/order_repository.dart';
import '../../data/models/create_order_request.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<OrderEntity> call(CreateOrderRequest request) {
    return repository.createOrder(request);
  }
}
