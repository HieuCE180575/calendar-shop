import '../entities/order.dart';
<<<<<<< HEAD
import '../entities/create_order_input.dart';
import '../repositories/order_repository.dart';
=======
import '../repositories/order_repository.dart';
import '../../data/models/create_order_request.dart';
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

<<<<<<< HEAD
  Future<OrderEntity> call(CreateOrderInput input) {
    return repository.createOrder(input);
=======
  Future<OrderEntity> call(CreateOrderRequest request) {
    return repository.createOrder(request);
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
  }
}
