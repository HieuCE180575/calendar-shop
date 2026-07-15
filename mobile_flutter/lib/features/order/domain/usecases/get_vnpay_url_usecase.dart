import '../repositories/order_repository.dart';

class GetVNPayUrlUseCase {
  final OrderRepository repository;

  GetVNPayUrlUseCase(this.repository);

  Future<String> call(int orderId) {
    return repository.getVNPayUrl(orderId);
  }
}
